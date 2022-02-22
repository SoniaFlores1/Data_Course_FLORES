library(tidyverse)

##Normal Distribution####

# make tidy dataframe of normal distribution sampling efforts

trials <- list()
j<- 1
for(i in c(10, 50, 100, 250, 1000, 3000, 5000, 10000, 100000)){
  trials[[j]] <- data.frame(x=rnorm(i), y=factor(i))
  j <- j+1
}


#Bionomial Distribution

trials <- list()
j<- 1


#probability of getting 2 heads out of 2 coin tosses
dbinom(x=2, size=2, prob=0.5)

library(palmerpenguins)
#Models####

#A "model" is an attempt to approximate reality with a simple equation.
#Here we can use 'species' to try to improve our predictive guess

mod1 <- glm(data= penguins, #glm = general linear model
            formula= bill_length_mm ~ species) 
#the tilde (~) denotes bill length as a function of species

mod1 %>% 
  summary

library(easystats)
library(modelr)

add_predictions(data = penguins,
                model = mod1)
#looks at our model formula to predict something as a function of something else
#in this case, it predicts bill length as a function of species

model_performance(mod1)

#can you come up with a model that is better?


penguins %>% names


mod2 <- glm(data= penguins,
            formula= bill_length_mm ~ species + island + bill_depth_mm+
              sex + year + body_mass_g + flipper_length_mm)

mod2 %>% summary
#we have some predictors that are better than others. 

add_predictions(penguins, mod2) 

#The predictions are getting closer to the actual bill lengths
add_predictions(penguins, mod2) %>% 
  ggplot(aes(x=body_mass_g , y=bill_length_mm, color= species, shape=sex))+
  geom_point() +
  geom_point(aes(y=pred), color="Black")

#Our model is taking into account more things and can predict something better

add_predictions(penguins, mod2) %>% 
  ggplot(aes(x=body_mass_g , y=bill_length_mm, color= species, shape=sex))+
  geom_point() +
  geom_smooth(method="lm", aes(y=pred, linetype=sex), color="Black")

add_predictions(penguins, mod2) %>% 
  ggplot(aes(x=body_mass_g , y=bill_length_mm, color= species, shape=sex))+
  geom_point() +
  geom_smooth(method="lm", aes(y=pred, linetype=species), color="Black")

#we can look at performance

performance(mod2)
#These indices give us a good idea on how well or bad our model is working
#R^2 tells us how much of an improvement our model is at explaining something
   #over just using a mean
#RMSE gives us a value that indicates how off it is. (Average error)
#For AIC, smaller value in this score is better.

performance(mod1)

#mod1 has a lower R^2, a higher RMSE, and higher AIC.

#between the two, mod2 is likely to be kept because it's performance scores are better

#let's make one more model.

mod3 <- glm(data= penguins,
            formula= bill_length_mm ~ species + bill_depth_mm+
              sex + body_mass_g + flipper_length_mm)

mod3 %>% summary

performance(mod1)
performance(mod2)
performance(mod3)

#mod3 has some scores that are better and some that are worse than our other models.
#sometimes, a simpler model is better, 
#which model you pick is up to how useable you think the models is and how much
  #you trust the scores.

mpg
mod4 <- glm(data=mpg,
            formula= cty ~ cyl + trans + drv)

mod4 %>% summary

mpg %>% 
  add_predictions(mod4) %>% 
  ggplot(aes(x= cyl, y=cty, color=trans))+
  geom_point()+
  geom_point(aes(y=pred), color="Black", alpha=0.25)

#4 cylinder is more difficult to predict, but it fits better for 6 and 8
  #cylinder cars.

data.frame(cyl=40, trans="manual(m5)", drv="f") %>% 
  add_predictions(mod4)

#a 40 cylinder car apparently GIVES you gas....
#models are not good at predicting things outside of the training it has
#Be careful when you try to get predictions outside of your model's range...
#It's also easier to over-fit versus under-fitting a model.
#basically you give your model too much info to take into account.

###PLEASE LOOK!#
#look at building_basic_models in Code_Examples to explore this concept more.
#Also look at hyp_testing_intro for learning hypothesis testing.
###SERIOUSLY PLEASE LOOK AT THIS!!! #




