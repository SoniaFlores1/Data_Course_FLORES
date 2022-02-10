library(tidyverse)

#I: Read the cleaned_covid_data.csv file into an R Data Frame

clean_cov<- read.csv("cleaned_covid_data.csv")
clean_cov %>% class()
summary(clean_cov)

#II; Subset the data set to just show states that begin with “A” 
#and save this as an object called A_states.

cov_a<-grepl(pattern="^A",clean_cov[,1])

A_states
