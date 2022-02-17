#Iris data set

iris
#hit control enter to see the data in the console.
#This is a data frame 

class(iris)

#data frame means it is a group of vectors that has inherent order
#Every column is a variable, and every row is an observation of the variables
#iris is looking at flower sepal and petal length from iris plant species.
#Most of the variables are numerical, save for species, which is character

#How many species are in this data set?

iris$Species

#We can see the levels of that variable. THere are three under species in Iris
# Setosa, Versicolor, and Viriginia

class(iris$Species)
#The class is listed as a Factor, which can list Levels. You won't be able to
#add another species unless you add it as a new factor to the list.

unique(iris$Species)
#this will give the unique values in this variable

table(iris$Species)
#this will give you a cross tab with the number of observations in those species
#there are 50 each. 

#Time to download an R package. 
#you can just click on the packages tab and install a package from there.
#Will usually install from CRAN. You can also look at packages on CRAN.
#It is the best way to find what kind of things you want to do.
#We will get Tidyverse.

#This will take a while...
#Now lets get easystats, but since it's not on CRAN, we need a new method.
#This will take us to a github repository with this package.

install.packages("easystats", repos = "https://easystats.r-universe.dev")

library(tidyverse)
#You should use the Library function before you start anything
#Tidy verse will show other packages under R
#It will also show you any conflicts with certain packages if they are there.

# %>%. get it with ctr+shift+m. output from left becomes 1st arguement to right function
  
iris %>% class()

iris$Species %>% table()

#We also get ggplot package with tidyverse. very useful for graphing plots.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) +
  geom_point() +
  geom_smooth()

#geom_smooth adds regression lines.

iris$Sepal.Length %>% mean()

#let us get data frames for the means of each species 
#One called setosa, one called viriginica and one called versicolor

iris$Sepal.Length > 6
iris$Species == "setosa"
iris[iris$Species == "setosa",] #will show the columns
#setosa
setosa<- iris[iris$Species == "setosa",]

setosa$Sepal.Length %>% mean()

#versicolor
versicolor<- iris[iris$Species == "versicolor",]

versicolor$Sepal.Length %>% mean()

#virginica
virginica<- iris[iris$Species == "virginica",]

virginica$Sepal.Length %>% mean()

#we can also get standard deviations using sd()

setosa$Sepal.Length %>% sd()
versicolor$Sepal.Length %>% sd()
virginica$Sepal.Length %>% sd()

#Here is another way to do this

iris %>% 
  group_by(Species) %>% 
  summarize(MeanSepLength = mean(Sepal.Length))

#This will give all the means in this group, like how we did above

iris %>% 
  group_by(Species) %>% 
  summarize(MeanSepLength = mean(Sepal.Length),
            SDSepLength = sd(Sepal.Length),
            MinSepLength = min(Sepal.Length),
            MaxSepLength = max(Sepal.Length))

#compare to summary

iris$Sepal.Length %>% summary()

iris %>% 
  ggplot(aes(x=Sepal.Length, color=Species))+
  geom_density()
#This plot shows the desnity calculation
#Most values for setosa fall near 5.
#This shows basically the distribution of the variables.
#in other words, the range of outcomes across a population
#For this example, sepal length in versicolor and viriginca are normally distributed.
#But not for setosa, which is skewed left.

iris %>% 
  ggplot(aes(x=Sepal.Width, color=Species))+
  geom_density()

#we NEVER remove outliers unless the outlier was gathered incorrectly.

#Now load easystats

library(easystats)

#let us install palmerpenguins
#It just us a dataset

library(palmerpenguins)

penguins

names(penguins)
#shows names of variables/columns
summary(penguins)
#shows summary of each column
#However it can't show how each point in the summary relates to other columns.
#It also shows you if there is no info available for some columns.

table(penguins$species,penguins$island)
#Will show you how the species and island columns relate to each other
#in other words, where and how many species of penguins are found on each island

#let's install GGally

library(GGally)
ggpairs(penguins)
#It will plot every variable against every other variable.
#can be useful if you know how to read it.
#Visual run down of various variable pairs.
#It also gives correlation coefficients. Gives negative and positive correlations.

#We'll recreate one of those plots

ggplot(penguins, aes(x=body_mass_g, y=flipper_length_mm, color=species)) +
  geom_point() +
  geom_smooth()

# ggplot layers
library(tidyverse)
library(palmerpenguins)

penguins %>% glimpse() #remember the pipe

#easier way to see what's going on in penguins

data(penguins)

#make a plot

p<- penguins %>% 
  ggplot(aes(x=bill_length_mm, y=body_mass_g, color=species))
#we saved this basic blank plot as p. 

p
#We can start stacking geometries onto this plot p, by layering with +

p + geom_point()

#penguins is the first argument to ggplot because it was piped in.
#How we display 

#we can modify our plots as well

p + geom_point(size=2, shape=12)
#whenever an aestethic is assigned to something, geom will apply those geometries

p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm")
#alpha is transparency between 0 and 1
#geom_smooth adds a regression line, with the method as "lm" keeps it in a linear model
#normally it would just curve around the data.

#We can add facets
p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~species)

#now we made separate subgraphs based off the information in the columns
#here are more examples of facets.
  
p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~sex)

p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island)

#Visualizing data can help use get more information about our data long before modelling

#We can apply different statistics to our data, even on our plot
#we can also change coordinates

p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island) +
  coord_flip()
#now the X and Y axes are switched. 
#You can also do other things, like removing the fixing of scales

p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island, scales="free") +
  coord_flip()
#you can also change cartesian points
p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island) +
  coord_cartesian(xlim=c(40,50), ylim=c(3000,4000))

#we can add themes to our plots
p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island) +
  coord_cartesian(xlim=c(40,50), ylim=c(3000,4000)) +
  theme_minimal()

#we can change other aspects as well
p + 
  geom_point(alpha=.25) + 
  geom_smooth(method="lm") +
  facet_wrap(~island) +
  coord_cartesian(xlim=c(40,50), ylim=c(3000,4000)) +
  theme(axis.title.x= element_text(face="bold", size=12, color="blue"),
        axis.text.x = element_text(angle=90, hjust=1, face="bold", size=16)) +
  labs(x="Bill Length (mm)", 
       y="Body Mass (g)", 
       title = "Ugly plot of penguins",
       subtitle= "whatever", 
       caption = "Data from palmerpenguins R package",
       color="Species of Penguin")

#this is a lot, but this graph is reproducible with this code.
#if our data changes, we can still use this code and will account for changes.

#Let us make our own plot

p2<- penguins %>% 
  ggplot(aes(x=bill_depth_mm, y=bill_length_mm, fill=species))

p2

p2 +
  geom_boxplot(alpha=.5) +
  facet_wrap(~species) +
  labs(x="Bill Depth(mm)", 
       y="Bill Length(mm)", 
       title = "Length Vs Depth of Penguin Bills",
       subtitle= "or something", 
       fill="Species of Penguin")






