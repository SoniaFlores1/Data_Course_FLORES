#Go to the gganimate and Utah_County_Map R files
#Download the packages listed in the libraries. Then Load the libraries
#tidyverse is a must!

library(tidyverse)

#Some stuff for the dplyr package

#filter() chooses rows based on expressions like COL == "ABC"
#group_by/summarize()
#mutate() makes new columns or replaces old columns based on existing columns
#arrange() is used to arrange data (rows) in certain ways based on the columns
    #desc() for descending order
#select() works like filter, but for columns instead of rows. Chooses based on name
    #starts_with()
    #ends_with()
    #contains()

#All these can be linked through pipes ( %>% )

iris %>%
  mutate(Sepal.Area= Sepal.Length * Sepal.Width) %>% 
  filter(Species != "setosa") %>% 
  filter(Sepal.Length < 6.5 & Sepal.Width < 2.75) %>% 
  ggplot(aes(x=Sepal.Length, y=Sepal.Area, color=Species)) +
  geom_point()

iris %>%
  filter(Species != "setosa") %>% 
  filter(Sepal.Length < 6.5 | Sepal.Width < 2.75) %>% 
  ggplot(aes(x=Sepal.Length, y=Sepal.Width, color=Species)) +
  geom_point()

iris %>% 
  select(Sepal.Length) %>% 
  arrange(desc(Sepal.Length))

iris %>% 
  select(starts_with("P"))

iris %>% 
  select(contains("tal"))


# & and | denote "and" and "or"

df<-read_csv("./Data/wide_income_rent.csv")

view(df)

df %>% 
  ggplot(aes(color=state, x=income, y=rent))+
  geom_col(poisiton="dodge")
#This can't be done because this data isn't tidy.

names(df) #To check the names of the columns
glimpse(df) #To see the class of data for each column

pivot_longer(df, !variable, names_to = "State", values_to="USD") %>% 
  ggplot(aes(color=variable, x=State, y=USD)) +
  geom_col(position = "dodge") + 
  theme(axis.text.x= element_text(angle=90, hjust=1))

df %>% 
  select(starts_with("Pue"))
#This shows why Puerto Rico seems to show no income on the graph.
#The data was not available for income for some reason.


utah<-read_csv("./Data/Utah_Religions_by_County.csv")

utah %>% 
  select(Religious, `Non-Religious`) %>% 
  rowSums()

utah %>% names
utah[,5:17] %>% rowSums()

utah %>% 
  pivot_longer(5:17)
#This technically is not correct

utah_long<-utah %>% 
  pivot_longer(-c("County","Pop_2010","Religious"), names_to="Religion",
               values_to= "Proportion")
#The - before c indicates to exclude what is in the vector
#Now that the plot is tidy, we can plot it!

evange_order<-utah_long %>% 
  filter(Religion == "Evangelical") %>% 
  arrange(desc(Proportion))
  

utah_long %>% 
  mutate(County=factor(County, levels= evange_order$County)) %>% 
  ggplot(aes(x=County, y=Proportion, fill=Religion))+
  geom_col() +
  theme(axis.text.x= element_text(angle=90, hjust=1))

#Remember these three rules for tidying data:
#1. Every Column is a variable
#2. Every Row is an observation
#3. Every cell is a value



