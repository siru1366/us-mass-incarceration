#### Preamble ####
# Purpose: Paper Replication
# Author: Sirui Tan
# Date: 11 February 2024 
# Contact: sirui.tan@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
install.packages("readr")
library(tidyverse)
library(rvest)
library(readxl)
library(knitr)
library(janitor)
library(lubridate)
library(dplyr)
library(ggpubr)
library(scales)
library(here)
library(kableExtra)
library(openxlsx)
library(haven) 

#### Reading data ####

url <- "https://www.prisonstudies.org/highest-to-lowest/prison_population_rate?field_region_taxonomy_tid=All"
page <- read_html(url)
table_data <- html_table(page)[[1]] 
write_csv(table_data, "inputs/data/country_data.csv") 

file_path <- here::here("inputs/data/mass incarceration.xlsx")
x0 <- read.xlsx(file_path, sheet = 1)

file_path_2 <- here::here("inputs/data/mass incarceration.xlsx")
men_data <- read.xlsx(file_path_2, sheet = 3)

admit_data <- read_dta(file = here::here("inputs/data/spi86to16.dta"))


#### Cleaning data ####
raw_data <- read_csv("inputs/data/country_data.csv")
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

c_data <-  read.csv(file = here::here("outputs/data/clean_country_data.csv"))

## CREATE FIGURE 1

par(mfrow=c(3,1))
par(fig=c(.05,.95, 2/3-.02, 1))
plot(x0$Year, x0$Prison.Rate.per.100k, type="l", col="blue",
     xlim=c(1920, 2020), ylim=c(0, 800),
     xlab="", ylab="Incarceration Rate (per 100,000)", lty=1, lwd=2)
title(" US Incarceration, 1925-2018")
lines(x0$Year, x0$TotalRate, lty=2, col="red", lwd=2)
legend(1925, 770, c("Prison and jail","Prison only"), lwd=2,
       lty=c(2,1), col=c("red","blue"), bty="n")
abline(h=seq(0, 800, 200), v=seq(1920,2020,20), lty=3, col="gray")

# Save the plot to a file
png("outputs/graphs/US_incarceration_1925−2018.png", width = 10, height = 6)
dev.off()


## CREATE FIGURE 2

men_data <- men_data %>%
  mutate(
    race = case_when(
      race == "W" ~ "White",
      race == "B" ~ "Black",
      TRUE ~ race
    ),
    cohort = case_when(
      cohort == "45-49" ~ "Born 1945-1949",
      cohort == "75-79" ~ "Born 1975-1979",
      TRUE ~ cohort
    )
  )
ggplot(men_data, aes(x = race, y = risk, fill = education)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~cohort) +
  labs(
    x = "Race",
    y = "Risk",
    fill = "Education") +
  theme_minimal()
# Save the plot to a file
ggsave(filename = "outputs/graphs/Men’s_cumulative_imprisonment_risk_cohort.png",  width = 10, height = 6)

## CREATE FIGURE 3
c_data <- data[order(-data$prison_population_rate), ]

# Create the bar plot
plot <- ggplot(c_data, aes(x =prison_population_rate, y = country)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme(axis.text.x = element_text(angle = 0, hjust = 1, vjust = 0.5)) +  # Rotate x-axis labels
  labs(x = "Prison Population Rate", y = "country")  # Add axis labels
# Save the plot to a file


## CREATE FIGURE 4



# Create the bar plot

x <- admit_data[admit_data$admit==1,] 

drugev  <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(drugev, wt, na.rm=T)))
drugev  <- drugev[!is.nan(drugev[,3]),]
vocev   <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(vocev, wt, na.rm=T)))
vocev   <- data.matrix(vocev[!is.nan(vocev[,3]),])
work    <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(work, wt, na.rm=T)))
work    <- data.matrix(work[!is.nan(work[,3]),])
edev    <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(edev, wt, na.rm=T)))
edev    <- data.matrix(edev[!is.nan(edev[,3]),])

dimnames(drugev) <- dimnames(vocev) <- dimnames(work) <- dimnames(edev) <-
  list(NULL, c("region","year","xbar"))

pdf("programs.pdf",height=6, width=8)
par(mfrow=c(1,4))
par(fig=c(0,.29, 0,1))
plot(drugev[drugev[,"region"]==1,"year"],
     drugev[drugev[,"region"]==1,"xbar"]*100,
     type="b", pch=16, main="Drug Program",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="Percent", xlab="")
axis(1)
axis(2)
lines(drugev[drugev[,"region"]==2,"year"], drugev[drugev[,"region"]==2,"xbar"]*100,
      type="b", pch=17, col="dodgerblue")
lines(drugev[drugev[,"region"]==3,"year"], drugev[drugev[,"region"]==3,"xbar"]*100,
      type="b", pch=18, col="red")
lines(drugev[drugev[,"region"]==4,"year"], drugev[drugev[,"region"]==4,"xbar"]*100,
      type="b", pch=19, col="blue")
legend(1986, 80, c("Northeast","Midwest","South","West"),
       pch=16:19, col=c("skyblue2", "dodgerblue", "red","blue"),
       lty=1, bty="n", cex=1.1)
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.237,.527, 0,1))
plot(edev[edev[,"region"]==1,"year"],
     edev[edev[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Education",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(edev[edev[,"region"]==2,"year"], edev[edev[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(edev[edev[,"region"]==3,"year"], edev[edev[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(edev[edev[,"region"]==4,"year"], edev[edev[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.473,.763, 0,1))
plot(vocev[vocev[,"region"]==1,"year"],
     vocev[vocev[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Job Training",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(vocev[vocev[,"region"]==2,"year"], vocev[vocev[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(vocev[vocev[,"region"]==3,"year"], vocev[vocev[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(vocev[vocev[,"region"]==4,"year"], vocev[vocev[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.71,1.0, 0,1))
plot(work[work[,"region"]==1,"year"],
     work[work[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Work",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(work[work[,"region"]==2,"year"], work[work[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(work[work[,"region"]==3,"year"], work[work[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(work[work[,"region"]==4,"year"], work[work[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
# Save the plot to a file
dev.off()


## CREATE FIGURE 5

# Create the bar plot

x <- admit_data[admit_data$admit==0,] 

drugev  <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(drugev, wt, na.rm=T)))
drugev  <- drugev[!is.nan(drugev[,3]),]
vocev   <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(vocev, wt, na.rm=T)))
vocev   <- data.matrix(vocev[!is.nan(vocev[,3]),])
work    <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(work, wt, na.rm=T)))
work    <- data.matrix(work[!is.nan(work[,3]),])
edev    <- data.matrix(x %>% group_by(region, year) %>% summarize(weighted.mean(edev, wt, na.rm=T)))
edev    <- data.matrix(edev[!is.nan(edev[,3]),])

dimnames(drugev) <- dimnames(vocev) <- dimnames(work) <- dimnames(edev) <-
  list(NULL, c("region","year","xbar"))

pdf("programs_2.pdf",height=6, width=8)
par(mfrow=c(1,4))
par(fig=c(0,.29, 0,1))
plot(drugev[drugev[,"region"]==1,"year"],
     drugev[drugev[,"region"]==1,"xbar"]*100,
     type="b", pch=16, main="Drug Program",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="Percent", xlab="")
axis(1)
axis(2)
lines(drugev[drugev[,"region"]==2,"year"], drugev[drugev[,"region"]==2,"xbar"]*100,
      type="b", pch=17, col="dodgerblue")
lines(drugev[drugev[,"region"]==3,"year"], drugev[drugev[,"region"]==3,"xbar"]*100,
      type="b", pch=18, col="red")
lines(drugev[drugev[,"region"]==4,"year"], drugev[drugev[,"region"]==4,"xbar"]*100,
      type="b", pch=19, col="blue")
legend(1986, 80, c("Northeast","Midwest","South","West"),
       pch=16:19, col=c("skyblue2", "dodgerblue", "red","blue"),
       lty=1, bty="n", cex=1.1)
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.237,.527, 0,1))
plot(edev[edev[,"region"]==1,"year"],
     edev[edev[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Education",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(edev[edev[,"region"]==2,"year"], edev[edev[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(edev[edev[,"region"]==3,"year"], edev[edev[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(edev[edev[,"region"]==4,"year"], edev[edev[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.473,.763, 0,1))
plot(vocev[vocev[,"region"]==1,"year"],
     vocev[vocev[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Job Training",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(vocev[vocev[,"region"]==2,"year"], vocev[vocev[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(vocev[vocev[,"region"]==3,"year"], vocev[vocev[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(vocev[vocev[,"region"]==4,"year"], vocev[vocev[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
par(new=T)
par(fig=c(.71,1.0, 0,1))
plot(work[work[,"region"]==1,"year"],
     work[work[,"region"]==1,"xbar"]*100, type="b", pch=16, main="Work",
     xlim=c(1986, 2016), ylim=c(0,80), col="skyblue2",
     axes=F, ylab="", xlab="")
axis(1)
lines(work[work[,"region"]==2,"year"], work[work[,"region"]==2,"xbar"]*100, type="b", pch=17, col="dodgerblue")
lines(work[work[,"region"]==3,"year"], work[work[,"region"]==3,"xbar"]*100, type="b", pch=18, col="red")
lines(work[work[,"region"]==4,"year"], work[work[,"region"]==4,"xbar"]*100, type="b", pch=19, col="blue")
abline(v=seq(1985, 2015, 10), h=seq(0,80, 20), col="gray",lty=3)
# Save the plot to a file
dev.off()


## CREATE FIGURE 6

# Create the bar plot


