library(tidyverse)
library(modelr)
library(easystats)

df <- read_csv("./Data/GradSchool_Admissions.csv")
df %>% glimpse() #For this, 1 is True, 0 is False. 

df<- df %>% 
  mutate(admit= case_when(admit==1~TRUE,
                          admit==0~FALSE), 
         rank=factor(rank)) #Rank is now a factor
#You can also do df$admit <- df$admit %>% as.logical()

df %>% glimpse()
library(GGally)
ggpairs(df)

#This set is both weird and interesting to look at.
#Most types of modelling looks at TRUE/FALSE scenarios.

#Logistic Regression: When Response Variable is a True/False
mod1<- glm(data=df,
           formula= admit ~ gre + gpa + rank,
           family= "binomial")

add_predictions(df, mod1, type= "response") %>% 
  ggplot(aes(x=gre, y=pred, color=rank)) +
  geom_smooth()

library(palmerpenguins)

penguins %>% glimpse

penguins<- penguins %>% 
  mutate(Fatty = case_when(body_mass_g>5000 ~ TRUE,
                           body_mass_g<=5000~FALSE))

mod2<- glm(data=penguins,
           formula= Fatty ~ bill_length_mm * bill_depth_mm,
           family= "binomial")

add_predictions(penguins, mod2, type ="response") %>% 
  ggplot(aes(x=bill_length_mm, y=pred))+
  geom_smooth()

#Cross-validation
training_set<- penguins %>% 
  slice_sample(prop = 0.75) #gives us a random 75% of our data set. random each time


testing_set<-anti_join(penguins, training_set) 
nrow(training_set) + nrow(testing_set) == nrow(penguins)

mod3<- glm(data=training_set,
           formula= bill_length_mm~ sex*species*body_mass_g)
add_predictions(data=testing_set, mod3) %>% 
  ggplot(aes(x=body_mass_g))+
  geom_point(aes(y=bill_length_mm, color=sex))+
  geom_point(aes(y=pred))
#rather than training your model on the full dataset, we use a percentage of the data
#to train the model, then use it on the remaining percentage.
#you get a different plot each time you run the full thing each time.
#Then you can look at all the resulting plots to see how well overall the model works.
#This is basically bootstrapping.


#import -> tidy -> visualize (plot) -> model -> communicate (What does it mean?)

#Does flipper_length_mm differ significantly between male and female penguins?
glimpse(penguins)

mod4<- glm(data=penguins,
           formula= flipper_length_mm ~ sex)
summary(mod4)
add_predictions(data=penguins, mod4) %>% 
  ggplot(aes(x=flipper_length_mm, color=sex))+
  geom_boxplot()
#AOV models
aov_mod<- penguins %>% 
  aov(data=.,
      formula=flipper_length_mm ~ sex * species)
summary(aov_mod)
#now do a Post-Hoc test on your anova model.
TukeyHSD(aov_mod) #%>% plot
penguins %>% glimpse

penguins %>% 
  filter(sex %in% c("male","female")) %>% 
  ggplot(aes(x=species, y=flipper_length_mm, fill=sex))+
  geom_boxplot()


#Does flipper_length_mm change from year to year?
penguins %>% 
  ggplot(aes(x=factor(year), y=flipper_length_mm))+
  geom_boxplot()
  #There seems to be a difference between years, but which is more significant?
#mod5<-glm(data=penguins,
      #formula= flipper_length_mm ~ year)
aov_mod2<- penguins %>% 
  aov(data=.,
      formula=flipper_length_mm ~ factor(year))

#summary(mod5)
summary(aov_mod2)
TukeyHSD(aov_mod2) %>% plot 
   #there is a significant difference between 2008-2007 and 2009-2007.
   #the differnece between 2009-2008 is not significant.

penguins %>% 
  mutate(year_f=factor(year)) %>% 
  ggplot(aes(x=year_f, y=flipper_length_mm, fill=sex))+
  geom_boxplot()+
  facet_wrap(~species)

penguins %>% 
  mutate(year_f=factor(year)) %>%
  aov(data=.,
      formula= flipper_length_mm ~ year_f+species+sex) %>% 
  TukeyHSD() %>% 
  plot

data("us_rent_income")

#tidy the data before doing anything
tidy_rent<-us_rent_income %>% 
  select(-moe) %>% 
  pivot_wider(id_cols= NAME,
              names_from= variable,
              values_from= estimate)

tidy_rent %>% 
  ggplot(aes(x=income,y=rent))+
  geom_point()+
  geom_smooth(method="lm")

#response = rent
#predictors = state(NAME), income

tidy_rent %>% 
  glm(data=.,
      formula= rent ~ income) %>% 
  summary()
