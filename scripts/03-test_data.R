#### Preamble ####
# Purpose: Tests the real datas
# Author: Sirui Tan
# Date: 10 February 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? No


#### Workspace setup ####

library(tidyverse)
library(readxl)
library(testthat)
library(testthat)
library(here)


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

#### Test real_data_2 ####
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



#### Test real_data_3 ####
library(testthat)
library(readxl)
library(here)

library(testthat)
library(here)

# Load the data
data_3 <- read_dta(file = here::here("inputs/data/spi86to16.dta"))

# Test 1: Check if the data frame has the correct number of rows
expect_equal(nrow(data_3), 62892)

# Test 2: Check if the data frame has the correct number of columns
expect_equal(ncol(data_3), 8)

# Test 3: Check if all columns are of numeric data type
expect_true(all(sapply(data_3, is.numeric)))

# Test 4: Check if all values in the 'region' column are within the expected range (1-4)
expect_true(all(data_3$region >= 1 & data_3$region <= 4))

# Test 5: Check if all values in the 'admit' column are  0 or 1 or NA
expect_true(all(data_3$admit %in% c(0, 1,NA)))

# Test 6: Check if all values in the 'year' column are within the expected range (1986-2016)
expect_true(all(data_3$year >= 1986 & data_3$year <= 2016))

# Display the first few rows of the data
head(data_3)
