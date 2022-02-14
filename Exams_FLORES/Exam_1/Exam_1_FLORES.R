library(tidyverse)

#I. Read the cleaned_covid_data.csv file into an R Data Frame

clean_cov<- read.csv("cleaned_covid_data.csv")
clean_cov %>% class()
summary(clean_cov)
glimpse(clean_cov)

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
  scale_x_discrete(breaks=c("2020-06-01","2021-01-01","2021-06-01","2022-01-01"))+
  theme(axis.text.x=element_text(angle=0, face="bold"),
        axis.text.y=element_text(face="bold"),
        axis.title.x= element_text(face="bold", size=12),
        axis.title.y=element_text(face="bold", size=12),
        strip.background = element_rect(colour="black", fill="#E6B9CC",
                                        size=1, linetype="solid"),
        strip.text.x = element_text(size=10,face="bold"))+
  labs(x="Date", 
       y="Number of Covid-19 Deaths")


#IV. (Back to the full dataset) Find the “peak” of Case_Fatality_Ratio 
#for each state and save this as a new data frame object called 
#state_max_fatality_rate.

max_rate <- clean_cov %>% select(Province_State, Case_Fatality_Ratio)

state_max_fatality_rate <- max_rate %>%
  group_by(Province_State) %>%
  summarize(Maximum_Fatality_Ratio = max(Case_Fatality_Ratio , na.rm = T)) %>%
  arrange(desc(Maximum_Fatality_Ratio))


#V. Use that new data frame from task IV to create another plot.

state_max_fatality_rate %>% 
  mutate(d_states = factor(Province_State, 
                             levels= state_max_fatality_rate$Province_State)) %>%
  ggplot(aes(x=d_states, y=Maximum_Fatality_Ratio))+
           geom_bar(stat="identity", fill="#28768A")+
  theme(axis.text.x=element_text(angle=90, face="bold",hjust =1,vjust=0.5),
        axis.title.x= element_text(face="bold", size=12),
        axis.title.y=element_text(face="bold", size=12),
        plot.title = element_text(hjust=0.5))+
  labs(x="US States and Provinces", y="Fatality Rates",
       title="Maximum Fatality Rates of Covid19\nin The United States of America")

#VI. (BONUS 10 pts) Using the FULL data set, plot cumulative deaths for the entire US over time
