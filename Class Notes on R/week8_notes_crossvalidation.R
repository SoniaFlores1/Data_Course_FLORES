library(tidyverse)
library(modelr)
library(easystats)
library(palmerpenguins)

penguins %>% glimpse

penguins <- penguins %>% 
  mutate(Fatty = case_when(body_mass_g > 5000 ~ TRUE,
                           body_mass_g <= 5000 ~ FALSE))

mod2 <- glm(data = penguins,
            formula = Fatty ~ bill_length_mm * bill_depth_mm,
            family="binomial")

add_predictions(penguins,mod2,type="response") %>% 
  ggplot(aes(x=bill_length_mm,y=pred)) +
  geom_smooth()


# Cross-validiation

# split data into training and testing sets
training_set <- penguins %>% slice_sample(prop = .75)
testing_set <- anti_join(penguins,training_set)

# train the model on the training set
mod3 <- glm(data=training_set,
            formula = bill_length_mm ~ sex * species * body_mass_g)

# Do this whole thing 100 times

# make empty lists to fill with the for-loop
mod_list <- list()
err_list <- list()

for(i in 1:100){
  training_set <- penguins %>% slice_sample(prop = .75)
  testing_set <- anti_join(penguins,training_set)
  
  mod3 <- glm(data=training_set,
              formula = bill_length_mm ~ sex * species * body_mass_g)
  mod_list[[i]] <- mod3 # fill the list with the models
  
  
  # test the model on the testing set and pull the error terms - add to err_list
  err_list[[i]] <- add_predictions(testing_set,mod3) %>% 
    mutate(error = abs(bill_length_mm - pred)) %>% 
    pluck("error")
}

#  compare the model stats for all 100 of those cross-validations
performance_list <- compare_performance(mod_list)
names(performance_list)

# Look at the distributions for R2
performance_list %>% 
  ggplot(aes(x=R2)) +
  geom_density()

# look at error terms for each model iteration
mean_abs_error <- err_list %>% 
  map_dbl(mean,na.rm=TRUE)

# distribution for absolute mean error among all iterations
data.frame(abs_error=mean_abs_error) %>% 
  ggplot(aes(x=abs_error)) +
  geom_density()
