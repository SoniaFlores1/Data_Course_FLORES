library(tidyverse)

#1.Import the 4 related datasets found in the Data_Course/Data/flights/ directory.

airlines<- read_csv("airlines.csv")
airports<- read_csv("airports.csv")
jan_flights<- read_csv("jan_flights.csv")
Jan_snowfall<- read_csv("Jan_snowfall.csv")

#2. Combine the data sets appropriately to investigate whether departure delay 
   #was correlated with snowfall amount

jan_flights2<-jan_flights %>% 
  unite(col = Date, YEAR, MONTH, DAY, sep = "-") %>% 
  mutate(Date= as.Date(Date)) %>% 
  group_by(Date, AIRLINE) %>% 
  summarize(mean_DEPDELAY= mean(DEPARTURE_DELAY, na.rm=T),
            mean_ARRDELAY= mean(ARRIVAL_DELAY, na.rm=T))

Jan_snowfall2<-Jan_snowfall %>% 
  rename(IATA_CODE = iata)

airports2<- airports %>% 
  select(IATA_CODE, AIRPORT, STATE)

airports_snowfall<- full_join(airports2, Jan_snowfall2, by="IATA_CODE")

Flights<- full_join(jan_flights2, airports_snowfall)

#3. Plot average departure delays by state over time
Flights %>% 
  ggplot(aes(x=Date, y=mean_DEPDELAY, color=STATE))+
  geom_smooth()
#4. Plot average departure delays by airline over time
Flights %>% 
  ggplot(aes(x=Date, y=mean_DEPDELAY, color=AIRLINE))+
  geom_smooth()
#5. Plot effect of snowfall on departure and arrival delays ________
  






library(tidyverse)
library(patchwork)

# set abs file path to Assignment_7
path <- "/home/gzahn/Desktop/GIT_REPOSITORIES/gzahn.github.io/data-course/Repository/Assignments/Assignment_7"

# find the csv files
files <- list.files(path,pattern = ".csv",full.names = TRUE)

# read them into a list
dfs <- map(files,read_csv)

# name the list elements by the csv filename
names(dfs) <- basename(files) %>% str_remove_all(".csv") %>% janitor::make_clean_names()
names(dfs)

# fix names in snowfall data set to match "IATA_CODE"
names(dfs$jan_snowfall) <- c("Date","IATA_CODE","snow_precip_mm")

# make "Date" column in flights; subset to necessary columns
dfs$jan_flights <- dfs$jan_flights %>% 
  mutate(Date=paste0(YEAR,"-",MONTH,"-",DAY) %>% as.Date()) %>% 
  select(c("Date","ORIGIN_AIRPORT","DESTINATION_AIRPORT","DEPARTURE_DELAY","ARRIVAL_DELAY"))

# join airports and snowfall; select IATA_CODE, Date, snow_precip_mm
dfs$weather <- full_join(dfs$airports,dfs$jan_snowfall) %>% 
  select(IATA_CODE,Date,snow_precip_mm)

# create df for departure delays and weather (rename ORIGIN_AIRPORT to IATA_CODE to pull in daily weather info)
departures <- dfs$jan_flights %>% 
  rename(IATA_CODE=ORIGIN_AIRPORT) %>% 
  select(-ARRIVAL_DELAY) %>% 
  full_join(dfs$weather) %>% 
  select(-c(IATA_CODE,DESTINATION_AIRPORT)) %>% 
  rename(DEPARTURE_SNOW=snow_precip_mm)


# create df for arrival delays and weather (rename DESTINATION_AIRPORT to IATA_CODE to pull in daily weather info)
arrivals <- dfs$jan_flights %>% 
  rename(IATA_CODE=DESTINATION_AIRPORT) %>% 
  select(-DEPARTURE_DELAY) %>% 
  full_join(dfs$weather) %>% 
  select(-c(IATA_CODE,ORIGIN_AIRPORT)) %>% 
  rename(ARRIVAL_SNOW=snow_precip_mm)

# remove data.frame list to free up space
rm(dfs)


# departure delay vs snow at departure airport
departures %>% 
  ggplot(aes(x=DEPARTURE_SNOW,y=DEPARTURE_DELAY)) +
  geom_smooth()

# delays correlation

departures$Type <- "Departure"
arrivals$Type <- "Arrival"


data.frame(delay=c(departures$DEPARTURE_DELAY,arrivals$ARRIVAL_DELAY),
           type=c(departures$Type,arrivals$Type),
           date=c(departures$Date,arrivals$Date)) %>% 
  ggplot(aes(x=date,y=delay,color=type)) +
  geom_smooth()



