library(tidyverse)

#I. Read the cleaned_covid_data.csv file into an R Data Frame

clean_cov<- read.csv("cleaned_covid_data.csv")
clean_cov %>% class()
summary(clean_cov)

#II. Subset the data set to just show states that begin with “A” 
#and save this as an object called A_states.

clean_cov[grepl("A",clean_cov$Province_State),]
A_states<-clean_cov[grepl("A",clean_cov$Province_State),]
summary(A_states)
glimpse(A_states)
#III. Create a plot of that subset showing Deaths over time, 
#with a separate facet for each state.
theme_set(theme_minimal())

A_states %>% 
  ggplot(aes(y=Deaths, x=Last_Update,color=Province_State))+
  geom_point(size=0.5, show.legend = FALSE)+
  geom_smooth(method="loess",aes(group=Province_State), color="black", se=FALSE)+
  facet_wrap(~Province_State, scales="free")+
  labs(x="Time", 
       y="Covid-19 Deaths",
       color="States")

?geom_smooth
?scale_x_date
?theme


#IV. (Back to the full dataset) Find the “peak” of Case_Fatality_Ratio 
#for each state and save this as a new data frame object called 
#state_max_fatality_rate.



#V. Use that new data frame from task IV to create another plot.



