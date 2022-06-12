
####Capstone project - cyclistic bike share dataset Analysis###

## SQL: Transforming data with BigQuery 
#Combining 12 tables of 12 months' Divvy Bike trip data into one table

CREATE TABLE cyclistic-bikeshare-220606.trip_data.cyclistic AS
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2101
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2102
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2103
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2104
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2105
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2106
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2107
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2108
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2109
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2110
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2111
  UNION ALL
  SELECT * FROM cyclistic-bikeshare-220606.trip_data.bikeride_2112;

# Mutate the table to add "ride_duration," "ride_month" and change days_of_week from number to string format

SELECT ride_id, bike_type, started_at, ended_at, start_station_name, end_station_name, user_type,
 DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_duration,
 EXTRACT (MONTH from started_at) AS ride_month,
 CASE
    WHEN day_of_week = 1 THEN 'Sunday'
    WHEN day_of_week = 2 THEN 'Monday'
    WHEN day_of_week = 3 THEN 'Tuesday'
    WHEN day_of_week = 4 THEN 'Wednsday'
    WHEN day_of_week = 5 THEN 'Thursday'
    WHEN day_of_week = 6 THEN 'Friday'
    ELSE 'Saturday'
 END AS day_of_week
 FROM `cyclistic-bikeshare-220606.trip_data.cyclistic`;
 
 ================================================
##R ANALYSIS
#Install packages for data cleaning

install.packages("tidyverse") 
install.packages("lubridate")
install.packages("ggplot2")

library(tidyverse)
library(lubridate)
library(ggplot2)

# Import and inspect the csv file from data combined in a big query
library(readr)
bq_final_data <- read_csv("JobHunt/Data Analytics Jobs/DataAnalytics_shortCourse/Google Data Analytics/Course 8 - Capstone_Project/Case_study-1/divvy-2021_dataset/bq_final_data.csv")
View(bq_final_data) #get peak of the data

glimpse(bq_final_data)#get peak of the data
head(bq_final_data)#get peak of the data
str(bq_final_data)
colnames(bq_final_data)#preview the data


#Further cleansing the dataset

clean_data <- bq_final_data %>%           #create an object that stores summary statistics
  filter(!is.na(start_station_name)) %>%  #Filtering rides not starting at a given station
  filter(!is.na(end_station_name)) %>%    #Filtering rides not ending at a given station
  filter(ride_duration > 0)               #Filtering out rides with duration <= 0


#Descriptive analysis
ride_Summary <- clean_data %>% 
  group_by(user_type, bike_type, day_of_week, ride_month) %>% 
  summarize(number_of_rides = n(), avg_ride_duration = mean(ride_duration))
View(ride_Summary)
write.csv(ride_Summary, file = "C:/Users/User/Documents/ride_Summary.csv")
