#Best practices for making a "clean" R script####

#Load packages####
library(tidyverse)
library(janitor)
library(modelr)
library(easystats)
library(broom)
    #please download and load these packages before starting!
#Set themes, etc. ####
theme_set(theme_minimal())
pal <- c("#2a782a", "#78351d", "#611d78")

#Load functions ####

#Import Data ####
df<- read_csv("./Data/Bird_Measurements.csv")
   #This file can also be read from a github repository website address
   #But only from the Raw data tab.

#Clean data ####
  #quick look
glimpse(df)
  #clean the column names
df<- clean_names(df)

  #split df into three data frames, one for each sex value
male<- df %>%
  select(-ends_with("_n")) %>% 
  select(family, species_number, species_name, english_name,
         clutch_size, egg_mass, mating_system, starts_with("m_")) %>% glimpse

female<- df %>%
  select(-ends_with("_n")) %>% 
  select(family, species_number, species_name, english_name,
         clutch_size, egg_mass, mating_system, starts_with("f_")) %>% glimpse

unsexed <- df %>%
  select(-ends_with("_n")) %>% 
  select(family, species_number, species_name, english_name,
         clutch_size, egg_mass, mating_system, starts_with("unsexed_")) %>% glimpse
   #pivot longer on each new split data frame and add a sex column back in
male<- male %>% 
  pivot_longer(starts_with("m_"),
               names_to= "measurement",
               values_to= "value",
               names_prefix = "m_") %>%
  mutate(sex="male")

female<- female %>% 
  pivot_longer(starts_with("f_"),
               names_to= "measurement",
               values_to= "value",
               names_prefix = "f_") %>%
  mutate(sex="female")

unsexed<- unsexed %>% 
  pivot_longer(starts_with("unsexed_"),
               names_to= "measurement",
               values_to= "value",
               names_prefix = "unsexed_") %>%
  mutate(sex="unsexed")

   #stick them all back together into one cleaned data frame
full<- full_join(male, female) %>% 
  full_join(unsexed)

   #remove unwanted objects from environment
rm(male)
rm(female)
rm(unsexed)
rm(df)
   #take a look at "full"
full %>% glimpse
   #we still need to clean it up a bit more
   #so now we have to separate out the tail, mass, tarsus, and bill measurements
   #pivot wider to get measurements into their own columns
full<-full %>% 
  pivot_wider(id_cols=-measurement,
              names_from=measurement,
              values_from=value)

  #Let's look at full once more
full %>% glimpse
  #our data is now clean!!!!
#Visualize data####
  
  #column names
  full %>% names
  #quick visualizations
  #let's look at egg size versus body size by sex
full %>% 
  ggplot(aes(x=egg_mass, y=mass, color=sex ))+
  geom_point() +
  facet_wrap(~sex)+
  scale_color_manual(values=pal)
ggsave("sf_myplot.png", height=4, width=4, dpi=300)

  #Wait...is mass normally distributed?
full %>% 
  ggplot(aes(x=mass))+
  geom_density()
  #uh...no....
  #the ostritch mass really skews the data.
full %>% 
  #filter(mass <= 250) %>%, but this is not advised since it removes data
  ggplot(aes(x=log10(mass)))+ #using a log transformation can better display all data
  geom_density()


#Model and test hypotheses ####
  #Don't forget to use the log10 of mass!
mod <- glm(data=full,
           formula= log10(mass) ~ egg_mass + sex,)
summary(mod)
  #we can save this summary of mod in a text file
sink("stat_table.txt", append=TRUE)
summary(mod)
sink(NULL)

  #tidy function from broom can let us see a tidy table of our results
tidy(mod) %>% 
  filter(p.value<0.05)

  #easystats can also give us a pretty good report, written in plain English!
report(mod)
