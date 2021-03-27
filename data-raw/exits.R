library(dplyr)
library(rvest)

exits <- read_html("https://en.wikipedia.org/wiki/Texas_State_Highway_Loop_1") %>%
  html_nodes("table") %>%
  .[[5]] %>%
  html_table(fill = TRUE) %>%
  as_tibble() %>%
  janitor::clean_names() %>%
  select(mi:notes) %>%
  slice(-n()) %>%
  mutate(across(mi:km, as.double),
         notes = if_else(stringr::str_length(notes) == 0, NA_character_, notes)) %>%
  rename(destination = destinations) %>%
  filter(!is.na(mi))

usethis::use_data(exits, overwrite = TRUE)
