#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
# [...UPDATE THIS...]

#### Test data ####
set.seed(123)

# Generate example data for 20 countries
countries <- paste("Country", 1:20)
prison_populations <- sample(1000:10000, 20, replace = TRUE)  # Example prison populations
national_populations <- sample(500000:5000000, 20, replace = TRUE)  # Example national populations

# Calculate prison population rates per 100,000
prison_rates <- (prison_populations / national_populations) * 100000

# Create a data frame to store the simulated data
simulated_data <- data.frame(
  Country = countries,
  Prison_Population = prison_populations,
  National_Population = national_populations,
  Prison_Rate_per_100000 = prison_rates
)

test_that("Data frame has the correct dimensions", {
  expect_equal(nrow(simulated_data), 20)
  expect_equal(ncol(simulated_data), 4)
})

test_that("Data frame contains required columns", {
  expect_true("Country" %in% names(simulated_data))
  expect_true("Prison_Population" %in% names(simulated_data))
  expect_true("National_Population" %in% names(simulated_data))
  expect_true("Prison_Rate_per_100000" %in% names(simulated_data))
})

test_that("Prison_Population and National_Population have valid values", {
  expect_true(all(simulated_data$Prison_Population >= 1000))
  expect_true(all(simulated_data$Prison_Population <= 10000))
  expect_true(all(simulated_data$National_Population >= 500000))
  expect_true(all(simulated_data$National_Population <= 5000000))
})

test_that("Prison_Rate_per_100000 falls within a reasonable range", {
  expect_true(all(simulated_data$Prison_Rate_per_100000 >= 0))
  expect_true(all(simulated_data$Prison_Rate_per_100000 <= 2000))  # A typical upper limit for prison rates
})
test_that("Country names are unique", {
  expect_true(length(unique(simulated_data$Country)) == nrow(simulated_data))
})
