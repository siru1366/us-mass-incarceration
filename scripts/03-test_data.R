#### Preamble ####
# Purpose: Tests the real data
# Author: Sirui Tan
# Date: 14 February 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? No


#### Workspace setup ####

library(tidyverse)
library(readxl)


#### Test real_data_1 ####
file_path <- here::here("inputs/data/mass incarceration.xlsx")
real_data_1 <- read.xlsx(file_path, sheet = 1)

# Check if min year is 1925
min_year_check <- min(real_data_1$Year) == 1925

# Check if max year is 2019
max_year_check <- max(real_data_1$Year) == 2019

# Check if min prison rate is >= 0
min_prison_rate_check <- min(real_data_1$Prison.Rate.per.100k) >= 0

# Print the test results
cat("Minimum year is 1925:", min_year_check, "\n")
cat("Maximum year is 2019:", max_year_check, "\n")
cat("Minimum prison rate is >= 0:", min_prison_rate_check, "\n")

file_path <- here::here("inputs/data/mass incarceration.xlsx")
# Read the Excel file
real_men_data <- read.xlsx(file_path, sheet = 3)

# Check if unique races are "W" and "B"
race_check <- all(unique(real_men_data$race) == c("W", "B"))

# Check if min risk is >= 0
risk_check <- min(real_men_data$risk) >= 0

# Print the test results
cat("Unique races are 'W' and 'B':", race_check, "\n")
cat("Minimum risk is >= 0:", risk_check, "\n")
