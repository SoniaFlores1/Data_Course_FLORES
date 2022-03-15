library(tidyverse)
library(easystats)
library(modelr)
library(GGally)

mushroom<- read.csv("../../Data/mushroom_growth.csv")

ggpairs(mushroom)
#models for GrowthRate
mod1<- glm(data=mushroom,
           formula= GrowthRate~ Species + Light + Nitrogen + Humidity + Temperature)

mod2<- glm(data=mushroom,
           formula= GrowthRate~ Species + Light + Humidity + Temperature)

mod3<-glm(data=mushroom,
          formula=GrowthRate~ Species + Light + Humidity)

mod4<-glm(data=mushroom,
          formula= GrowthRate~ Species * Light * Humidity)

mod5<-glm(data=mushroom,
          formula=GrowthRate ~ Species * Light * Humidity * Temperature)

mod6<- glm(data=mushroom,
           formula = GrowthRate~ Species * Light * Humidity * Temperature * Nitrogen)
#comparing the models
compare_models(mod1, mod2, mod3, mod4, mod5, mod6)
compare_performance(mod1, mod2, mod3, mod4, mod5, mod6) %>% plot()

mushroom %>% 
  gather_residuals(mod1,mod2,mod3, mod4, mod5, mod6) %>% 
  ggplot(aes(x=model,y=resid,fill=model)) +
  geom_boxplot(alpha=.5) +
  geom_point() + 
  theme_minimal()

