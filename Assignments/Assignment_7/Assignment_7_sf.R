library(tidyverse)

#1.Import the 4 related datasets found in the Data_Course/Data/flights/ directory.

airlines<- read_csv("airlines.csv")
airports<- read_csv("airports.csv")
jan_flights<- read_csv("jan_flights.csv")
Jan_snowfall<- read_csv("Jan_snowfall.csv")

#2. Combine the data sets appropriately to investigate whether departure delay 
   #was correlated with snowfall amount

#3. Plot average departure delays by state over time
#4. Plot average departure delays by airline over time
#5. Plot effect of snowfall on departure and arrival delays _____________