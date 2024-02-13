#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(rvest)
library(tidyverse)


#### Download data ####

# Define the URL of the webpage
url <- "https://www.prisonstudies.org/highest-to-lowest/prison_population_rate?field_region_taxonomy_tid=All"

# Read the webpage
page <- read_html(url)

# Extract the table containing the data
table_data <- html_table(page)[[1]]  

#### Save data ####

write_csv(table_data, "inputs/data/country_data.csv") 

         
