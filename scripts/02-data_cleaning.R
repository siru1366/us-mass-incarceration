#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("inputs/data/country_data.csv")

cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  select(title, prison_population_rate) |>
  filter(title%in% c ("United States of America","Turkey","United Kingdom: England & Wales","Spain",
                         "France","Austria", "Italy","Belgium","Switzerland",
                      "Ireland", "Germany" ,"Denmark" ,"Norway","Netherlands", "Sweden",
                      "Finland","Chile","Canada","Norway","Singapore","Japan","Brazil"))|>
rename(country=title)

 

#### Save data ####
write_csv(cleaned_data, "outputs/data/clean_country_data.csv")
