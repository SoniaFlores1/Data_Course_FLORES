library(tidyverse)
library(broom)
mod<- mpg %>% 
  glm(data=.,
      formula=cty ~ displ + manufacturer)

tidy(mod) %>% 
  mutate(term= term %>% str_remove_all("manufacturer"))

x<- c("your mom","you suck","you are worthless","you're a loser")
x

#capitalize each 
y<-paste0(x,".")

y
str_to_sentence(y)
str_to_title(y)
str_to_upper(y)

x %>% 
  paste0(".") %>% 
  str_to_sentence()

#turn "you're" into "you are", then split the sentences.
x %>% 
  paste0(".") %>% 
  str_replace_all("you're","you are") %>% 
  str_to_sentence() %>% 
  str_split(" ")


y %>% 
  str_remove_all("your") %>% 
  str_remove_all("you") %>% 
  str_remove_all("you're") %>% 
  str_remove_all("^ ")


