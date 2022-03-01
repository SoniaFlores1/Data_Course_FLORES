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