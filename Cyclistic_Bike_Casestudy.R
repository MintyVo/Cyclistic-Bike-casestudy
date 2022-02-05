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

jan20212 <- read_csv("202201-divvy-tripdata.csv")
str(jan2022)
head(jan2022)








