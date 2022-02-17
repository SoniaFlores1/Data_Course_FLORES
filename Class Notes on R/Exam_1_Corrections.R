library(tidyverse)
library(gganimate)
#I
clean_cov<-read_csv("./Exams_FLORES/Exam_1/cleaned_covid_data.csv")
  
clean_cov %>% names()
#II
A_states <- clean_cov %>% filter(grepl("^A", Province_State),)

A_states %>% 
  ggplot(aes(x=Last_Update, y=Deaths)) +
 geom_point()+
 geom_smooth(se=FALSE)+
 facet_wrap(~Province_State, scales ="free")

#III
state_max_fatality_rate <- clean_cov %>% 
  group_by(Province_State) %>% 
  summarize(Maximum_Fatality_Ratio = max(Case_Fatality_Ratio, na.rm = TRUE)) %>% 
  arrange(desc(Maximum_Fatality_Ratio))


#V
state_max_fatality_rate %>% 
  mutate(orderedstate= factor(Province_State, levels = Province_State)) %>% 
  ggplot(aes(x=orderedstate, y=Maximum_Fatality_Ratio))+
  geom_col()+
  theme(axis.text.x= element_text(angle=90, hjust=1))
  

#BONUS

clean_cov %>% 
  group_by(Last_Update) %>% 
  summarize(cummulativedeath = sum(Deaths)) %>% 
  ggplot(aes(x=Last_Update, y=cummulativedeath))+
  geom_point()


