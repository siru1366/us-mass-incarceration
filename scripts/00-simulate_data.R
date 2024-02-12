#### Preamble ####
# Purpose: Simulates... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
# [...ADD CODE HERE...]
# Set seed for reproducibility
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

# Print the simulated data
head(simulated_data)



