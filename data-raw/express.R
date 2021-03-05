library(tidyverse)
library(lubridate)
library(sift)

express_counts <- read_csv("data-raw/express_counts.txt", col_names = FALSE) %>%
  transmute(time = str_sub(X1, end = 19) %>% as_datetime(tz = "US/Central"))

# for blog post
write_csv(express_counts, here::here("inst", "extdata", "express_counts.csv"))


# t1 <- 5 # dataset will start at 5am
# t2 <- 20 # dataset will end at 8pm
#
#
# # helper fn
# calculate_density <- function(t) {
#   t <- hour(t) + minute(t) / 60
#
#   d <- dnorm(t, mean = 9) + dnorm(t, mean = 13, sd = 3) + dnorm(t, mean = 17)
#   d <- d / max(d)
# }
#
# # tibble(t = seq(as_datetime("2020-05-19 05:00:00", tz = "US/Central"), as_datetime("2020-05-19 20:00:00", tz = "US/Central"), by = dminutes(5))) %>%
# #   mutate(traffic_density = calculate_density(t)) %>%
# #   ggplot(aes(t, traffic_density)) +
# #   geom_point()
#
# # sift:::mopac_raw %>%
# #   group_by(day) %>%
# #   mutate(t_delta = time_length(time - lag(time))) %>%
# #   ungroup() %>%
# #   rowid_to_column() %>%
# #   as_tsibble(index = rowid) %>%
# #   gg_tsdisplay()
# # #
# # mopac_raw %>%
# #   group_by(day) %>%
# #   mutate(t_delta = time_length(time - lag(time))) %>%
# #   ggplot(aes(t_delta)) +
# #   geom_histogram()
#
# # get traffic spacing
# set.seed(10)
# t_delta <- sift:::mopac_raw %>%
#   with_groups(day,
#               mutate,
#               t_delta = time_length(time - lag(time))) %>%
#   drop_na(t_delta) %>%
#   mutate(t_delta = t_delta + 2 * rbeta(n(), 2, 5)) %>% # sprinkle some jitter into timestamps (observations were recorded with 1 sec resolution - this needs to be finer)
#   pull(t_delta)
#
# # generate timestamps
# total_seconds <- (t2 - t1) * 3600
#
# tibble(toll_booth = c("North", "South")) %>%
#   rowwise(toll_booth) %>%
#   summarize(vehicle_spacing = sample(t_delta, size = total_seconds, replace = TRUE)) %>%
#   filter(cumsum(vehicle_spacing) < total_seconds) %>%
#   mutate(timestamp = make_datetime(2020, 5, 9, 5, tz = "US/Central") + cumsum(vehicle_spacing))
