library(dplyr)
library(rvest)

exits <- read_html("https://en.wikipedia.org/wiki/Texas_State_Highway_Loop_1") %>%
  html_nodes("table") %>%
  .[[5]] %>%
  html_table(fill = TRUE) %>%
  as_tibble() %>%
  select(mi:Notes) %>%
  slice(-n()) %>%
  mutate(across(mi:km, as.double),
         Notes = if_else(stringr::str_length(Notes) == 0, NA_character_, Notes)) %>%
  filter(!is.na(mi))

usethis::use_data(exits, overwrite = TRUE)
