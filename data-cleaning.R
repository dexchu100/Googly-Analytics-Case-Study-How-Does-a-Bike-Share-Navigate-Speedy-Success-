#Cleaning the Data for Analysis

install.packages("tidyverse") #collection of r packages that would be useful to me
install.packages("lubridate") #help with conversions of Dates and Time
install.packages("dplyr")
install.packages("tidyr")
library(tidyverse)
library(lubridate)
library(dplyr)
library(tidyr)

#Setting up where to get the data
getwd()
setwd("C:/Users/dexch/Documents/cyclist-data")
getwd()

#Collecting the Data
data_2021_12 <- read.csv("202112-divvy-tripdata.csv")
data_2022_01 <- read.csv("202201-divvy-tripdata.csv")
data_2022_02 <- read.csv("202202-divvy-tripdata.csv")
data_2022_03 <- read.csv("202203-divvy-tripdata.csv")
data_2022_04 <- read.csv("202204-divvy-tripdata.csv")
data_2022_05 <- read.csv("202205-divvy-tripdata.csv")
data_2022_06 <- read.csv("202206-divvy-tripdata.csv")
data_2022_07 <- read.csv("202207-divvy-tripdata.csv")
data_2022_08 <- read.csv("202208-divvy-tripdata.csv")
data_2022_09 <- read.csv("202209-divvy-tripdata.csv")
data_2022_10 <- read.csv("202210-divvy-tripdata.csv")
data_2022_11 <- read.csv("202211-divvy-tripdata.csv")



#Inspecting the data
col(data_2021_12)
col(data_2022_01)
col(data_2022_02)
col(data_2022_03)
col(data_2022_04)
col(data_2022_05)
col(data_2022_06)
col(data_2022_07)
col(data_2022_08)
col(data_2022_09)
col(data_2022_10)
col(data_2022_11)

str(data_2021_12)
str(data_2022_01)
str(data_2022_02)
str(data_2022_03)
str(data_2022_04)
str(data_2022_05)
str(data_2022_06)
str(data_2022_07)
str(data_2022_08)
str(data_2022_09)
str(data_2022_10)
str(data_2022_11)

#Surprisingly, there are no inconsistent data typing throughout the data so there is nothing to convert or fix
#Putting all data into a single data frame
united_data <- bind_rows(data_2021_12, data_2022_01, data_2022_02, data_2022_03, data_2022_04, data_2022_05, data_2022_06, data_2022_07, data_2022_08, data_2022_09, data_2022_10, data_2022_11)

#inspecting the new data frame
col(united_data)
str(united_data)
summary(united_data)

#cleaning the Data
united_data <- drop_na(united_data)

#adding the date columns
united_data["date"] <- as.Date(united_data$started_at)
united_data["month"] <- format(as.Date(united_data$date), "%m")
united_data["day"] <- format(as.Date(united_data$date), "%d")
united_data["year"] <- format(as.Date(united_data$date), "%Y")
united_data["day_of_the_week"] <- format(as.Date(united_data$date), "%A")

#get ride_length and check if they are numeric value for calculations
united_data["ride_length"] <- difftime(united_data$ended_at, united_data$started_at)
is.numeric(united_data$ride_length)
#convert to numeric values
as.character(united_data$ride_length)
united_data$ride_length <- as.numeric(united_data$ride_length)
is.numeric(united_data$ride_length)

#Finally Remove the negative values and other unwanted values, which represent bike that were taken out of circulation
final_united_data <- united_data[!(united_data$start_station_name == "HQ QR" | united_data$ride_length<0),]

#Export the final data into a full csv file for descriptive analysis
write.csv(final_united_data, "C:/Users/dexch/Documents/cyclist-data\\all-2022-divvy-tripdata.csv", row.names = FALSE)


