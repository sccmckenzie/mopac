library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(lubridate)
library(jsonlite)

options(readr.default_locale = locale(tz = "US/Central"))

rush_hour <- read_csv("https://raw.githubusercontent.com/sccmckenzie/mopac/master/inst/extdata/rush_hour.csv")

express_counts <- read_csv("https://raw.githubusercontent.com/sccmckenzie/mopac/master/inst/extdata/express_counts.csv")

set.seed(10)
t_delta <- express_counts %>%
  mutate(t_delta = time_length(time - lag(time))) %>%
  drop_na(t_delta) %>%
  mutate(t_delta = t_delta + 2 * rbeta(n(), 2, 3)) %>%
  # ^ we add some jitter into timestamps
  # (observations were recorded with 1 sec resolution)
  pull(t_delta)

# set timeframe (5am - 8pm)
t1 <- 5
t2 <- 20
total_seconds <- (t2 - t1) * 3600

set.seed(20)
express <- tibble(direction = c("North", "South")) %>%
  rowwise(direction) %>%
  summarize(vehicle_spacing = sample(t_delta, size = total_seconds, replace = TRUE)) %>%
  # ^ generate temporal vehicle spacing
  transmute(time = make_datetime(2020, 5, 20, t1, tz = "US/Central") + cumsum(vehicle_spacing)) %>%
  # ^ add temporal vehicle spacing together
  filter(time < make_datetime(2020, 5, 20, t2, tz = "US/Central"))
# ^ cut off timestamps later than 8pm

steck <- jsonlite::fromJSON('https://data.austintexas.gov/resource/sh59-i6y9.json?atd_device_id=6409&year=2020&month=5&day=20&heavy_vehicle=false') %>%
  as_tibble() %>%
  janitor::clean_names() %>%
  filter(direction == "SOUTHBOUND") %>%
  transmute(read_date = as_datetime(read_date, tz = "US/Central"),
            direction,
            movement,
            volume = as.integer(volume)) %>%
  with_groups(read_date,
              summarize,
              volume = sum(volume)) %>%
  transmute(id = row_number(),
            read_date,
            volume = volume/max(volume))

# join Steck volume with express timestamps
set.seed(25)
express <- express %>%
  mutate(id = findInterval(time, steck$read_date)) %>%
  left_join(steck, by = "id") %>%
  rowwise() %>%
  mutate(keep = sample(c(FALSE, TRUE), prob = c(1 - volume, volume), size = 1)) %>%
  # ^ treat volume as probability of keeping row in express
  ungroup() %>%
  filter(keep) %>%
  select(direction, time) %>%
  arrange_all()

hourday <- function(t) {
  time_length(t - make_datetime(2020, 5, 20, tz = "US/Central"), unit = "hours")
}

set.seed(254)
scenario_1 <- express %>%
  sample_n(size = 5000) %>%
  mutate(v_id = row_number())

set.seed(400)
scenario_2A <- express %>%
  anti_join(scenario_1) %>%
  # ^ exclude observations already sampled into scenario_1
  group_by(direction) %>%
  # ^ need equal amounts of north & south samples
  sample_n(size = 1000, weight = dnorm(hourday(time), mean = 7, sd = 2)) %>%
  mutate(id = row_number()) %>%
  ungroup()

scenario_2B <- express %>%
  anti_join(scenario_1) %>%
  anti_join(scenario_2A) %>%
  group_by(direction) %>%
  sample_n(size = 1000, weight = dnorm(hourday(time), mean = 17, sd = 2)) %>%
  mutate(id = row_number()) %>%
  ungroup()

set.seed(451)
North <- sample(filter(scenario_2A, direction == "North")$time)
South <- sample(filter(scenario_2B, direction == "South")$time)

set.seed(90)

# I arbitrarily set the number of repetitions to 100,
# which is ultimately more than enough to achieve desired result
scenario_2_sim <- bind_rows(
  map_dfr(1:100, ~ {
    tibble(i = ..1,
           direction = "NS",
           North = filter(scenario_2A, direction == "North")$time %>% sample(),
           South = filter(scenario_2B, direction == "South")$time %>% sample())
  }),
  # now we flip the directions
  map_dfr(1:100, ~ {
    tibble(i = ..1,
           direction = "SN",
           South = filter(scenario_2A, direction == "South")$time %>% sample(),
           North = filter(scenario_2B, direction == "North")$time %>% sample())
  })
) %>%
  mutate(l = if_else(direction == "NS",
                     time_length(South - North, unit = "hours"),
                     time_length(North - South, unit = "hours"))) %>%
  with_groups(c(direction, i), filter, !any(l < 0.5))

library(broom)
scenario_2 <- scenario_2_sim %>%
  group_by(direction, i) %>%
  summarize(vec = list(l)) %>%
  rowwise() %>%
  mutate(shapiro.test(vec) %>% tidy()) %>%
  filter(p.value < 0.1) %>%
  group_by(direction) %>%
  slice_max(order_by = statistic) %>%
  semi_join(scenario_2_sim, .) %>%
  transmute(North, South, v_id = max(scenario_1$v_id) + row_number()) %>%
  pivot_longer(North:South, names_to = "direction", values_to = "time")

set.seed(100)
scenario_3 <- express %>%
  anti_join(scenario_1) %>%
  anti_join(scenario_2) %>%
  sample_n(size = n()) %>%
  mutate(v_id = (row_number() - 1) %% 3 == 0,
         v_id = cumsum(v_id) + max(scenario_2$v_id)) %>%
  arrange(v_id, time)

scenario_3 <- scenario_3 %>%
  group_by(v_id) %>%
  mutate(delta = time_length(time - lag(time), unit = "hours")) %>%
  filter(!any(delta < 1, na.rm = TRUE)) %>%
  ungroup() %>%
  slice_head(n = 300) %>%
  # ^ 3 rows / vehicle * 100 vehicles = 300 rows
  select(direction, time, v_id)

set.seed(99)
robbery_A <- express %>%
  anti_join(scenario_1) %>%
  anti_join(scenario_2) %>%
  anti_join(scenario_3) %>%
  sample_n(size = 2, weight = dnorm(hourday(time), mean = 12, sd = 0.1)) %>%
  mutate(v_id = max(scenario_3$v_id) + row_number())

robbery_B <- express %>%
  anti_join(scenario_1) %>%
  anti_join(scenario_2) %>%
  anti_join(scenario_3) %>%
  sample_n(size = 2, weight = dnorm(hourday(time), mean = 17, sd = 0.1)) %>%
  mutate(v_id = max(scenario_3$v_id) + row_number())

robbery <- bind_rows(robbery_A, robbery_B)

express <- express %>%
  anti_join(scenario_1) %>%
  anti_join(scenario_2) %>%
  anti_join(scenario_3) %>%
  anti_join(robbery) %>%
  mutate(v_id = max(robbery$v_id) + row_number()) %>%
  bind_rows(scenario_1, scenario_2, scenario_3, robbery) %>%
  arrange(direction, time)

vehicle_probs <- rush_hour %>%
  drop_na() %>%
  count(day, make, model) %>%
  group_by(day) %>%
  mutate(wt = n / sum(n)) %>%
  group_by(make, model) %>%
  summarize(wt_mean = mean(wt), .groups = "drop") %>%
  mutate(wt = wt_mean / sum(wt_mean), .keep = "unused")

color_probs <- rush_hour %>%
  drop_na() %>%
  count(make, model, color) %>%
  group_by(make, model) %>%
  mutate(wt = n / sum(n)) %>%
  ungroup()

set.seed(98)
express <- express %>%
  distinct(v_id) %>%
  # make/model
  bind_cols(sample_n(vehicle_probs,
                     size = nrow(.),
                     weight = wt,
                     replace = TRUE)) %>%
  select(!wt) %>%
  # color
  full_join(color_probs) %>%
  group_by(v_id) %>%
  sample_n(size = 1, weight = wt) %>%
  select(!(n:wt)) %>%
  inner_join(express, .) # join it all back with express

set.seed(97)
plate_letters <- crossing(L1 = LETTERS, L2 = LETTERS, L3 = LETTERS) %>%
  mutate(st = str_c(L1, L2, L3, sep = "")) %>%
  pull(st) %>%
  sample(., n_distinct(express$v_id), replace = TRUE)

plate_numbers <- 0:9999
plate_numbers <- str_pad(plate_numbers, side = "left", pad = "0", width = 4) %>%
  sample(., n_distinct(express$v_id), replace = TRUE)

plates <- str_c(plate_letters, plate_numbers, sep = "-")

express <- express %>%
  distinct(v_id) %>%
  mutate(plate = plates) %>%
  inner_join(express, .) %>%
  relocate(plate, .before = make) %>%
  select(!v_id)

use_data(express, overwrite = TRUE)
write_csv(express, here::here("inst", "extdata", "express.csv"))
