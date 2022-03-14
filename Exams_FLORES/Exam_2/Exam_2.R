library(tidyverse)
library(easystats)
library(modelr)

#1. Read in the unicef data 
unicef<- read.csv("unicef-u5mr.csv")
#2. Get it into tidy format 
unicef2<-unicef %>% 
  pivot_longer(-c(CountryName, Continent, Region),
               names_to="Year",
               values_to="U5MR",
               names_prefix="U5MR.") %>% 
  mutate(Year= as.numeric(Year))

#3. Plot each country’s U5MR over time
unicef2 %>% 
  ggplot(aes(x=Year, y=U5MR, color=CountryName))+
  geom_line(size=1, show.legend = FALSE)+
  facet_wrap(~Continent)

#4. Save this plot as LASTNAME_Plot_1.png 
ggsave("FLORES_Plot_1.png", width=6, height =5, dpi=300)

#5. Create another plot that shows the mean U5MR for all the countries
#within a given continent at each year
unicef2 %>% 
  group_by(Continent, Year, CountryName) %>% 
  summarize(mean_U5MR=mean(U5MR)) %>%
  ggplot(aes(x=Year, y=mean_U5MR, color=Continent))+
  geom_line(size=1)


#6. Save that plot as LASTNAME_Plot_2.png 
ggsave("FLORES_Plot_2.png", width=6, height =5, dpi=300)

#7. Create three models of U5MR
mod1<- glm(data=unicef2,
           formula= U5MR ~ Year)
summary(mod1)
mod2<- glm(data=unicef2,
           formula= U5MR ~ Year + Continent)
summary(mod2)
mod3<- glm(data=unicef2,
           formula= U5MR ~ Year * Continent)
summary(mod3)
#8. Compare the three models with respect to their performance
performance(mod1)
performance(mod2)
performance(mod3)
compare_performance(mod1,mod2,mod3)
compare_performance(mod1,mod2,mod3) %>% plot()
  #Out of the 3 models, it appears that the model 3 would be the best model to use
  #when compared to other models. While mod1 has the lowest R2 value, it has a high
  #RMSE compared to the other two. mod3 has the lowest AIC and BIC score compared to 
  #the others.

#9. Plot the 3 models’ predictions
add_predictions(data=unicef2, mod1)
add_predictions(data=unicef2, mod2)
add_predictions(data=unicef2, mod3)

unicef2 %>% 
  gather_predictions(mod1,mod2,mod3) %>% 
  ggplot(aes(x=Year, y=pred, color=Continent)) +
  geom_line(size=2)+
  facet_wrap(~model)

#10. BONUS - Using your preferred model, predict what the U5MR would be for Ecuador 
#in the year 2020. The real value for Ecuador for 2020 was 13 under-5 deaths per 
#1000 live births. How far off was your model prediction???
data.frame(Continent="Americas", Year=2020, CountryName="Ecuador") %>% 
  add_predictions(mod3)
  #my model ended up predicting -10.58018 under 5 deaths per 1000 live births.

mod4<- glm(data=unicef2,
           formula=U5MR ~ Year * Continent + CountryName)
summary(mod4)
performance(mod4)

data.frame(Continent="Americas", Year=2020, CountryName="Ecuador") %>% 
  add_predictions(mod4)
  #With this model, I got a predicted value of 14.93849 for Ecuador in 2020,
  #which is fairly close to the actual value of 13.
