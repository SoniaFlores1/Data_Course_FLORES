library(tidyverse)
library(gganimate)
library(palmerpenguins)

#message from Dr. Zahn

data_frame(t=seq(-pi, 0, .001),
           x1=16*(sin(t))^2,
           x2=-x1,
           y=13*cos(t) -5 * cos(2*t) -2*cos(3*t) - cos(4*t)) %>%
  gather(side, x, x1, x2) %>%
  ggplot(aes(x,y)) +
  geom_polygon(fill="red") +
  coord_fixed() +
  theme_minimal()

table1 #This table is in tidy format. Every column is a variable and rows
       #are observations.
table2 #Cases and populations are in a column called "type," but it is tidy.
       #Because type is a variable and cases or population are observations.
       #Still, they could be variables in their own right.
table3 #Rate should not be placed as a character vector, but it is still tidy.
table4a #
table4b # 4a and 4b have cases and popluations in separate tables completely.
        #neither of them is tidy since year is a variable and should be
        #in its own column. Also the table shouldn't have been split.
table5  #It is set up weird, but can be considered tidy, maybe

#Let's fix table2
?pivot_wider #widens data by increasing number of columsn and decreasing number
             #of rows
table2 %>% 
  pivot_wider(id_cols = c(country,year), #which cols give us unique rows?
              names_from= type, #which column to split?
              values_from= count) #where to find values to fill?
#Now we have a new able where cases and population are separate columns
#each column is filled with values from the old count column

#Let's fix table3
#we want to split the column called rate by what is separated by the dash
?separate #Turns a single character column into multiple columns
          
table3 %>% 
  separate(rate, #what column do we want to separate?
           into= c("cases","population")) #What do we name the new columns?
#Now the values in the old rate column that were separated by a dash are now
#split into cases and population columns.
#a space also works as a dash in most cases as well and can be split there.
#the convert function in separate can be used to change components in the column

#Let's now fix table 4a and 4b, which should be in one table.
table4a #has cases
table4b #has population

#first they both have to have a column with either cases or population
#We need to places observations back into rows instead of columns
?pivot_longer #Takes variables and swing them into rows.
x<-table4a %>% 
  pivot_longer(-country,    #if there are too many column values it is easier to say which to exclude
               names_to= "year",
               values_to= "case")

#let's do the same to 4b

y<-table4b %>% 
  pivot_longer(-country,
               names_to= "year",
               values_to= "population")
#Now we must unite these tables together, but how?

?full_join #takes two data frames, looks for which columns are similar to join them
          #without duplicating them and creates new columns for the columns are are dissimilar

full_join(x,y) #We need to name our tables "x" and "y" for this to work
#Now we have a new table that is a united version of table4a and table4b.

#There are more join functions depending on what data you have and how you want
#them to join together. 

#Let's fix table5 with what we learned so far
#we will also use unite to unite two columns within a data frame
table5 %>% 
  separate(rate, into=c("cases","population")) %>% 
  unite(col="year", #new name for column
        sep="",  #what to separate values by; ""= nothing
        century,year) %>%  #names of the columns to paste together
  mutate(year=as.numeric(year),  #We mutate these columns to be numeric instead of character
         cases=as.numeric(cases),
         population=as.numeric(population))

#We have learned how to clean up some data. 

#Quick reminder about pivot_longer and pivot_wider

#pivot_longer is used when variables(columns) should be observations(rows)
#pivot_wider is used when observations(rows) should be variables(columns)

df<- read.csv("./Data/Bird_Measurements.csv")

mutate(case_when())


penguins %>% names

penguins %>% 
  ggplot(aes(x=species,y=body_mass_g, color=body_mass_g))+
  geom_jitter()

penguins %>% 
  mutate(opinion=case_when(body_mass_g > 5000 ~ "chonky",
                           body_mass_g <= 5000 ~ "not chonky")) %>% 
  ggplot(aes(x=species, y=body_mass_g, color=opinion))+
  geom_jitter()


case_when()

df<-read_csv("./Data/BioLog_Plate_Data.csv")

df %>% 
  pivot_longer(starts_with("Hr_"),
               names_to= "Time",
               values_to= "Absorbance", 
               names_prefix= "Hr_") %>% 
  mutate(Time=as.numeric(Time)) %>% 
  mutate(SampleType = case_when(`Sample ID` == "Clear_Creek" ~ "Water",
                                `Sample ID` == "Waste_Water" ~ "Water",
                                TRUE ~ "Soil")) %>% 
  ggplot()

table1 %>% 
  filter(year == 2000 & cases > 3000) %>% 
  select(-year) %>% 
  mutate(rate = (cases/population)*100) %>% 
  arrange(desc(rate, population))

table2 %>% 
  pivot_wider(id_cols = c(country,year), #what to leave behind
              names_from=type, #which column has new variables
              values_from=count) #which column has the values

table3 %>% 
  separate(rate, 
           into= c("cases","population"))
#Quotations marks are used because you are naming new columns that weren't there before
 
full_join(
table4a %>% 
  pivot_longer(-country,
               names_to="year",
               values_to="cases"),
table4b %>% 
  pivot_longer(-country,
               names_to="year",
               values_to="population")
)



pivot_longer()
pivot_wider()
mutate()
arrange()
filter() #pick rows based on some statements
select() 


library(janitor)

iris %>% names

janitor::clean_names(iris) %>% names

iris<- clean_names(iris)

gganimate

df <- read_csv("./Data/BioLog_Plate_Data.csv")

df %>% 
  pivot_longer(starts_with("Hr_"), names_to ="time", values_to ="absorbance",
               names_prefix = "Hr_") %>% 
  mutate(time=as.numeric(time)) %>% 
  filter(Substrate == "L-Arginine") %>% 
  ggplot(aes(x=time, y=absorbance))+
  geom_point()+
  facet_wrap(~Rep) +
  gganimate::transition_reveal(time)

