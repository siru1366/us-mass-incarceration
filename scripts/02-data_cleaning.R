#### Preamble ####
# Purpose: Cleans the raw data to gain just 20 countries data.
# Author:  Sirui Tan
# Date: 10 February 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? No

#### Workspace setup ####
library(tidyverse)


# Read in the raw data from the CSV file
raw_data <- read_csv("inputs/data/country_data.csv")

# Clean the data
cleaned_data <- 
  raw_data |>  # Pipe operator for cleaner syntax
  janitor::clean_names() |>  # Clean column names
  select(title, prison_population_rate) |>  # Select only relevant columns
  filter(title %in% c ("United States of America","Croatia","United Kingdom: England & Wales","Spain",
                       "France","Austria", "Italy","Belgium","Switzerland",
                       "Ireland", "Germany" ,"Denmark" ,"Norway","Netherlands", "Sweden",
                       "Finland","Egypt","Canada","Norway","Singapore","Japan","Iceland")) |>  # Filter specific countries
  rename(country = title)|>  # Rename 'title' column to 'country'
  rename(prison_rate_per100000 = prison_population_rate)
# Save the cleaned data to a new CSV file
write_csv(cleaned_data, "outputs/data/clean_country_data.csv")
