#### Preamble ####
# Purpose: Downloads and saves the data from World Prison Brief
# Author: Sirui Tan 
# Date: 10 February 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? No

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

         
