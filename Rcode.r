#### Google DATA ANALYTICS Capstone Project - Cyclistic Divvy Bike Share Dataset Analysis ###

## DATA ANALYSIS using R

##Install and loading R packages for data cleaning

install.packages("tidyverse") 
install.packages("lubridate")
install.packages("ggplot2")

library(tidyverse)
library(lubridate)
library(ggplot2)

## Import and inspect the csv file obtained from a big query
*Preliminary data inspection and cleaning was done during the google sheet/Excel dataset preparation phase. 
*Data cleaning in R included the following:
-Familiarize with the data set. 
-Check for structural errors.
-Check for data irregularities.


library(readr)
bq_final_data <- read_csv("users/user/Capstone_Project/Case_study-1/divvy-2021_dataset/bq_final_data.csv")
View(bq_final_data) #view the data

glimpse(bq_final_data)#get peek at the dataframe
head(bq_final_data)#get quick look at the data
str(bq_final_data) #learn structures of the dataset
colnames(bq_final_data)#preview the data


##Cleansing the dataset
*This step deals with filtering out the missing and/or null values in columns ignored by SQL.

clean_data <- bq_final_data %>%           #create an object that stores summary statistics
  filter(!is.na(start_station_name)) %>%  #Filtering rides not starting at a given station
  filter(!is.na(end_station_name)) %>%    #Filtering rides not ending at a given station
  filter(ride_duration > 0)               #Filtering out rides with duration <= 0


##Descriptive analysis of trip data
#Computing number of rides and average ride length for day of a week and month
ride_Summary <- clean_data %>% 
  group_by(user_type, bike_type, day_of_week, ride_month) %>% 
  summarize(number_of_rides = n(), avg_ride_duration = mean(ride_duration))
View(ride_Summary)

##Exporting the dataframe for data visualization in Tableau
write.csv(ride_Summary, file = "C:/Users/User/Documents/ride_Summary.csv")
