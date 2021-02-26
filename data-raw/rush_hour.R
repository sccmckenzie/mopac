library(dplyr)
library(purrr)
library(readr)
library(stringr)
library(lubridate)
library(readxl)

time_datum <- c("2020-05-17 17:27:00",
                "2020-05-18 18:24:00",
                "2020-05-19 18:00:00",
                "2020-05-20 18:00:00",
                "2020-05-21 18:00:00",
                "2020-05-22 18:00:00",
                "2020-05-23 15:00:00") %>%
  as_datetime(tz = "US/Central")

raw1 <- map_dfr(.x = 1:2, .f = ~ {
  read_excel("data-raw/mopac.xlsx", sheet = ..1) %>%
    mutate(day = wday(..1, label = TRUE),
           time = time_datum[[..1]] + dseconds(time))
})

raw2 <- map_dfr(.x = 3:7, .f = ~ {N
  read_excel("data-raw/mopac.xlsx", sheet = ..1) %>%
    mutate(day = wday(..1, label = TRUE),
           time = sprintf("%.2f", time),
           time = time_datum[[..1]] + dminutes(as.integer(str_extract(time, "^\\d+"))) + dseconds(as.integer(str_extract(time, "\\d+$"))))
})

rush_hour <- bind_rows(raw1, raw2) %>%
  janitor::clean_names() %>%
  relocate(c(day, time), .before = everything())

usethis::use_data(rush_hour, overwrite = TRUE)

write_csv(rush_hour, here::here("inst", "extdata", "rush_hour.csv"))
