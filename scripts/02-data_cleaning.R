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
  rename(country = title)  # Rename 'title' column to 'country'

# Save the cleaned data to a new CSV file
write_csv(cleaned_data, "outputs/data/clean_country_data.csv")
