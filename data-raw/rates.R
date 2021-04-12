library(readr)
library(dplyr)
library(tidyr)

rates <- read_csv("data-raw/rates.csv") %>%
  pivot_longer(South:North, names_to = "direction", values_to = "rate") %>%
  group_by(direction) %>%
  arrange(direction, time) %>%
  filter(rate != lag(rate, default = 0)) %>%
  ungroup() %>%
  relocate(direction)

use_data(rates, overwrite = TRUE)
