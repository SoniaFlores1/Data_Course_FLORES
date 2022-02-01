#The start of Week 4
#Remember to load in packages that you want to use. Mainly, Tidyverse.
library(tidyverse)
#load any other packages, as well.
library(palmerpenguins)

theme_set(theme_minimal(), theme(axis.text.x= element_text(angle=60,hjust=1)))
   #This will set the theme of plots you make automatically
   #However, it can be overriden if you applied a theme later in a different plot

##MASSIVE NOTE# Turn in Assignment 4: Give an idea for the Final Project!
penguins %>% glimpse #sees a quick rundown of this data set

#Single variable plots
ggplot(penguins,aes(x=bill_length_mm, fill=species)) + geom_density(alpha=0.5)
#Sometimes you don't need X or Y. This is the plot of a single variable
#Aesthetics are always asking for columns, so be careful not to put certain
#changes into the call for aesthetics. 

ggplot(penguins,aes(x=bill_length_mm, fill=species)) + geom_histogram(alpha=0.5)
#This is the opposite of Density
#Not all chart types need (or even accept) both x and y aesthetics.

#Double variable plots
#body mass vs bill length (basic scatterplot)
ggplot(penguins, aes(x=body_mass_g, y=bill_length_mm)) +
  geom_point(aes(color=species)) + 
  geom_smooth(method="lm", aes(linetype=species), color="black")
#"lm" refers to "Linear Model, which adds smoothing lines based of of a linear regression
#Anything inside the aes will only apply the columns called.
#anything outside of aes applies to the entire graph
ggplot(penguins, aes(x=body_mass_g, y=bill_length_mm)) +
  geom_point(aes(color=species)) + 
  geom_smooth(method="lm", aes(group=species), color="black")

#Group aesthetic won't map a column to a way of displaying it.
#It will just split up by whatever was called inside the aes.
#The greyed out area around the line is a confidence interval. 
#This can also be removed.

ggplot(penguins, aes(x=body_mass_g, y=bill_length_mm)) +
  geom_point(aes(color=species), alpha=0.5) + 
  geom_smooth(method="lm", aes(group=species), color="black", se=FALSE)
#If you want to only apply transparency to the plot points, use alpha within
#geom_point.
#The same applies to any geom if you only want to change something related to it.

#Let's add labels
ggplot(penguins, aes(x=body_mass_g, y=bill_length_mm)) +
  geom_point(aes(color=species), alpha=0.5, size=4) + 
  geom_smooth(method="lm", aes(group=species), color="black", se=FALSE) +
  labs(x="Body Mass (g)", 
       y="Bill Length (mm)",
       color="Species",
       title="Body Mass vs Bill Length\nin three penguin species") +
  theme_minimal() +
  theme(plot.title = element_text(hjust=0.5)) +
  scale_color_viridis_d()

#\n will move text in a new line to wrap text

#you can add a theme to change the background of the plot,
#You can also add customization to the theme using just theme.
#you can add scales to alter color scales (in this case grey scale for color-blind friendliness)
#Other scales can give you different color schemes that are color blind friendly
#Just make sure they work with the plot you have. (discrete, continuous, etc.)

#Now let's save this plot
#ggsave by default will save the last plot that you made.
ggsave("myplot.pdf",width=6, height =5, dpi=300)
#It will save it to your working directory unless otherwise indicated.
#If you save it again with some changes, it will change over the previous plot
#when they have the same name and file type. 
#png files will add transparency. you can use jpg to save without transparency
#the dpi should be set up to 300 as a standard. It can be higher for posters
#or lower for web viewing

#Making custom color palates

pal<-c("#276938", "#5b4b94", "#782332")

ggplot(penguins, aes(x=body_mass_g, y=bill_length_mm)) +
  geom_point(aes(color=species), alpha=0.5, size=4) + 
  geom_smooth(method="lm", aes(group=species), color="black", se=FALSE) +
  labs(x="Body Mass (g)", 
       y="Bill Length (mm)",
       color="Species",
       title="Body Mass vs Bill Length\nin three penguin species") +
  theme_minimal() +
  theme(plot.title = element_text(hjust=0.5)) +
  scale_color_manual(values = pal)

#you can use google's color selector to find a color and obtain a hexcode.


#To find built in data (from both R and from other packages)
data("band_instruments")

