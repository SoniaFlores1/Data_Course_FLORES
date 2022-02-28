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
  



