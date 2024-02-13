#### Preamble ####
# Purpose: Simulates example data for 20 countries including prison populations, national populations, and prison rates per 100,000 people.
# Author: Sirui Tan 
# Date: 8 February 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? NO


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
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



