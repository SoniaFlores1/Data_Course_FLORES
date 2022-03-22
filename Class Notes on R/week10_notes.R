library(tidyverse)
#Function practice####
#write a function that returns 'min', 'mean', 'median', and 'max' from a 
#given numeric vector

fn_summary<-function(x){
  mi<- min(x)
  m<- mean(x)
  me<- median(x)
  max<- max(x)
  return(c(mi, m, me, max))
}
fn_summary(1:10)
#check
summary(1:10)

fn_summary(c(2,5,7,2,9,15,35))
#It works, however the values are not specified as min, mean, etc.

#Dr. Zahn's similar function
mmmm<- function(x){
  if(!is.numeric(x)){
    stop("Idiot. Use numeric values only!")
  }
  MIN<- min(x)
  MEAN<- mean(x)
  MEDIAN<- median(x)
  MAX<- max(x)
  return(data.frame(MIN,MEAN,MEDIAN,MAX))
}

mmmm(1:10)
mmmm(c("1","2","3","4"))

#write a function that vies a plot of any given color palate
pal<-c("Blue","Red","Yellow","Green")

view.pal <- function(pal){
p<-ggplot()+
  geom_col(aes(x=pal, fill=pal, y=1))+
  scale_fill_manual(values=pal)+
  theme(axis.text=element_blank(),
        legend.position='none')
  print(p)
}

view.pal(viridis::inferno(10))
view.pal(viridis::rocket(10))

#R Markdown####
#Now, time to turn things like this into a proper report
#They can be turned into an html format and opened in an internet browser.
#Open an R Markdown file under the New File dropdown menu in the file dropdown.

#Rmd is basically the shortcut of html
#go to that file now.

