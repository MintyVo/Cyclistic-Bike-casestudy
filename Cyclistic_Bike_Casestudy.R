# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("tidyr")
# install.packages("here")
# install.packages("skimr")
# install.packages("janitor")
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
library(here)
library(skimr)
library(janitor)

#import data 
setwd("/Users/minty/Developer/Cyclistic-Bike-casestudy")
feb2021 <- read_csv("202102-divvy-tripdata.csv")
str(feb2021)
head(feb2021)

mar2021 <- read_csv("202103-divvy-tripdata.csv")
str(mar2021)
head(mar2021)

apr2021 <- read_csv("202104-divvy-tripdata.csv")
str(apr2021)
head(apr2021)

ma2021 <- read_csv("202105-divvy-tripdata.csv")
str(ma2021)
head(ma2021)

jun2021 <- read_csv("202106-divvy-tripdata.csv")
str(jun2021)
head(jun2021)

jul2021 <- read_csv("202107-divvy-tripdata.csv")
str(jul2021)
head(jul2021)

aug2021 <- read_csv("202108-divvy-tripdata.csv")
str(aug2021)
head(aug2021)

sep2021 <- read_csv("202109-divvy-tripdata.csv")
str(sep2021)
head(sep2021)

oct2021 <- read_csv("202110-divvy-tripdata.csv")
str(oct2021)
head(oct2021)

nov2021 <- read_csv("202111-divvy-tripdata.csv")
str(nov2021)
head(nov2021)

dec2021 <- read_csv("202112-divvy-tripdata.csv")
str(dec2021)
head(dec2021)

jan2022 <- read_csv("202201-divvy-tripdata.csv")
str(jan2022)
head(jan2022)

#combine all data into one table 

bike_data <- rbind(feb2021,mar2021,apr2021,ma2021,jun2021,jul2021,aug2021,sep2021,oct2021,nov2021,dec2021,jan2022)
head(bike_data,10)

#make a copy of the data to have a backup 
bike_data1 <- bike_data

#add a date column 
bike_data1$date <- as.Date(bike_data1$started_at)
head(bike_data1$date)

#add a month column
bike_data1$month <- format(as.Date(bike_data1$started_at), "%b_%y") 
head(bike_data1$month)

#add a day column 
bike_data1$day <- format(as.Date(bike_data1$date), "%d")
head(bike_data1$day)

#add a year column
bike_data1$year <- format(as.Date(bike_data1$date), "%Y") 
head(bike_data1$year)

#add a day of week column
bike_data1$weekday <- format(as.Date(bike_data1$date), "%A")
head(bike_data1$weekday)

#add a time started column
bike_data1$time <- format(bike_data1$started_at, format = "%H:%M")
head(bike_data1$time)

#change format for the time column for purposes later
bike_data1$time <- as.POSIXct(bike_data1$time, format = "%H:%M")
head(bike_data1$time)

#calculate ride length in minutes
bike_data1$ride_length <- (as.double(difftime(bike_data1$ended_at, bike_data1$started_at))) /60  
head(bike_data1$ride_length)


#examine the data 
str(bike_data1)
colnames(bike_data1)
dim(bike_data1) 
nrow(bike_data1)
summary(bike_data1)


#clean the data 

#remove duplicates
bike_data1 <- distinct(bike_data1)  

#get rid of negative ride 
bike_data1 <- bike_data1[!bike_data1$ride_length<1,] 
#get rid of the ride that is longer than one day or 1440 mins
bike_data1 <- bike_data1[!bike_data1$ride_length>1440,]

#change a few column names for clarification
bike_data1 <- rename(bike_data1, customer_type = member_casual) 
bike_data1 <- rename(bike_data1, bike_type = rideable_type)

## Filter out data we will not be using and remove missing data
bike_data1 <- bike_data1 %>% select(bike_type, customer_type, started_at, date, month, day, year, weekday, time, ride_length)
drop_na(bike_data1)

remove_empty(bike_data1)
remove_missing(bike_data1) 

# order data to based on day of week and by month 
bike_data1$weekday <- ordered(bike_data1$weekday, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", 
                                                           "Friday", "Saturday", "Sunday"))
bike_data1$month <- ordered(bike_data1$month, levels=c("Feb_21", "Mar_21", "Apr_21",  "May_21", "Jun_21","Jul_21", "Aug_21", "Sep_21", "Oct_21","Nov_21","Dec_21","Jan_2021"))

#Analyze the data

#shows the min, max, median, and average ride lengths
summary(bike_data1$ride_length)

#looks at total number of customers broken down by membership details
table(bike_data1$customer_type)

#looks at total rides for each customer type in minutes
setNames(aggregate(ride_length ~ customer_type, bike_data1, sum), c("customer_type", "total_ride_length(mins)"))

##look at rides based on customer type
bike_data1 %>% 
  group_by(customer_type) %>% 
  summarise(min_length = min(ride_length), max_length = max(ride_length), 
            median_length = median(ride_length), mean_length = mean(ride_length))

#look at ride lengths broken down by day of week and customer type
aggregate(bike_data1$ride_length ~ bike_data1$customer_type + bike_data1$weekday, FUN = median)

##look at total number of rides and averages based on day of week and customer type
bike_data1 %>% 
  group_by(customer_type, weekday) %>% 
  summarise(total_rides = n(), avg_ride = mean(ride_length)) %>% 
  arrange(weekday)

#Visualization 

#total rides broken down by weekday
bike_data1 %>%    
  group_by(customer_type, weekday) %>% 
  summarise(number_of_rides = n() ) %>% 
  arrange(customer_type, weekday) %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = customer_type)) + geom_col(position = "dodge") + 
  labs(x= 'Day of Week', y='Total Number of Rides', title='Rides per Day of Week', fill = 'Type of Membership') +
  scale_y_continuous(breaks = c(250000, 400000, 550000), labels = c("250K", "400K", "550K"))

#total rides broken down by month
bike_data1 %>%  
  group_by(customer_type, month) %>%  
  summarise(total_rides = n(),`average_duration_(mins)` = mean(ride_length)) %>% 
  arrange(customer_type) %>% 
  ggplot(aes(x=month, y=total_rides, fill = customer_type)) + geom_col(position = "dodge") + 
  labs(x= "Month", y= "Total Number of Rides", title = "Rides per Month", fill = "Type of Membership") + 
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000), labels = c("100K", "200K", "300K", "400K")) + theme(axis.text.x = element_text(angle = 45))