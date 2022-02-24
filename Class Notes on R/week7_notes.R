library(tidyverse)

library(tidyverse)

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

library(tidyverse)
library(modelr)
library(easystats)
library(GGally)

#plot city mpg
df<-mpg

df %>% names()

ggpairs(df, columns = c("cty","displ","drv"))

df %>% 
  ggplot(aes(x=displ, y=cty, color=drv)) + 
  geom_point()
#this model uses two predicting variables for city mpg

mod1<- glm(data=df,
           formula= cty~ displ) #displacement on cty

mod2<- glm(data=df,
           formula= cty ~ displ + drv) #displacement and drive on cty

mod3<- glm(data=df,
           formula= cty~ displ * drv) #displacement and drive on cty where
                                     #displacement varies with drive

summary(mod1)
#slope is -2.6, y-intercept is 26. 
summary(mod2)
#slope is -2.33, y-intercept is 23.6. for front-wheel drive, 2.27 is added.
           #for rear-wheel, 2.5 is added.
summary(mod3)


compare_models(mod1, mod2, mod3, style="se_p")
#in mod 3, rear_wheel drive drops in significance.
#intercept changes in all of them. Which one is the true intercept?
     #(Technically none of them, but some models have a better approximation)
compare_performance(mod1,mod2,mod3)
#Mod3 has a better R^2, but about 26% of the data can not be explained by the model.
#Root-Mean-Square Error predicts how far from reality our predicted line is,
#and all the models are close to each other in score.

compare_performance(mod1,mod2,mod3) %>% plot() #graphical comparison

#look at a model predictions for a hypothetical car.
hyp_preds<- data.frame(displ=6, drv ="r") %>% 
  gather_predictions(mod1,mod2,mod3)
#if the car has a displacement of 6 and rear-wheel drv, what are its miles per gallon
hyp_preds
#all models are giving us different predictions for what the mpg should be.

gather_predictions(data=df, mod1,mod2,mod3) %>% 
  ggplot(aes(x=displ, y=cty, color=drv)) +
  geom_point()+
  geom_smooth(method="lm", aes(y=pred), se=FALSE)+
  facet_wrap(~model)+
  geom_point(data= hyp_preds, aes(x=displ, y=pred),color="Black")

#revisit our model formulae
mod1$formula
mod2$formula
mod3$formula

#closer look at interactions
#interactons####

sim3
#y is response, x1 and x2 are predictors
mod1<-glm(data=sim3,
    formula= y~ x1 + x2) #without interaction

mod2<-glm(data=sim3,
    formula= y~ x1 * x2) #with interaction
summary(mod1)
summary(mod2)

compare_models(mod1,mod2)
compare_performance(mod1,mod2)
compare_performance(mod1,mod2) %>% plot()

sim3 %>% 
  gather_predictions(mod1,mod2) %>% 
  ggplot(aes(x=x1, y=pred, color=x2))+
  geom_smooth(method="lm")+
  facet_wrap(~model)

sim3 %>% 
  ggplot(aes(x=x1,y=y,color=x2))+
  geom_point()

library(MASS)
mpg %>% names
mod3<- glm(data=mpg,
           formula=cty ~ displ * year * cyl * drv * model)

step<- stepAIC(mod3)   #stepAIC will help with removing variables from 
                        #complicated models


step$formula

mod4<-glm(data=mpg,
          formula=step$formula)

add_predictions(mpg,mod4) %>% 
  ggplot(aes(x=displ,y=pred, color=factor(cyl)))+
  geom_smooth(method="lm")

mpg %>% 
  ggplot(aes(x=displ, y=cty))+
  geom_point()

mod5<- glm(data=mpg,
           formula= cty~ poly(displ,2)) #second order polynomial

add_predictions(mpg,mod5) %>% 
  ggplot(aes(x=displ))+
  geom_point(aes(y=cty))+
  geom_smooth(aes(y=pred))


