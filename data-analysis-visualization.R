#Descriptive Analysis

install.packages("tidyverse")
install.packages("ggplot2")
install.packages("lubridate")
install.packages("dplyr")
install.packages("tidyr")
library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(dplyr)

#Setting up where to get the data
getwd()
setwd("C:/Users/dexch/Documents/cyclist-data")
getwd()

#Getting the full data
cyclist_data <- read.csv("all-2022-divvy-tripdata.csv")


# Descriptive analysis on ride_length (all figures in seconds)
mean(cyclist_data$ride_length) 
median(cyclist_data$ride_length) 
max(cyclist_data$ride_length) 
min(cyclist_data$ride_length) 

# You can condense the four lines above to one line using summary() on the specific attribute
summary(cyclist_data$ride_length)

# Compare members and casual users
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual, FUN = mean)
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual, FUN = median)
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual, FUN = max)
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual + cyclist_data$day_of_the_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
cyclist_data$day_of_week <- ordered(cyclist_data$day_of_the_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual + cyclist_data$day_of_the_week, FUN = mean)

# analyze ridership data by type and weekday
cyclist_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()						
            ,average_duration = mean(ride_length)) %>% 	
  arrange(member_casual, weekday)								

# Let's visualize the number of rides by rider type
cyclist_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
cyclist_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
counts <- aggregate(cyclist_data$ride_length ~ cyclist_data$member_casual + cyclist_data$day_of_week + cyclist_data$month + cyclist_data$rideable_type + cyclist_data$start_station_name, FUN = mean)
write.csv(counts, file = 'C:/Users/dexch/Documents/cyclist-data/avg_ride_length.csv')

