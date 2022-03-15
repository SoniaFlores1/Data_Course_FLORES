library(tidyverse)
library(easystats)
library(modelr)
#Writing your own functions

fn1<-function(x){
  z<-x^2
  return(z)
}
fn1(2)

fn_pythag<-function(A,B){
  C <- sqrt(A^2 + B^2)
  return(C)
}
fn_pythag(3,3)
fn_pythag(A= 5, B= 10)

fn_pythag(A=c(1,2,3), B=c(3,4,5))

fn_sum<-function(A,B,C){
  if(!is.numeric(A)| !is.numeric(B)| !is.numeric(C)){ #Custom error message
    stop("Hey, A, B, and/or C needs to be numeric")
  }
  S<- sum(A,B,C)
  return(S)
}
fn_sum(4,6,8) #answer is 18. This works
fn_sum("1","2",3) #answer should be 6, but not when numbers are not listed as numeric

#Functions can be saved as an R file, and you can call the function into 
#another script using the source() function. It will load in your current project.
#However unlike packages, you will have to know exactly where that file lives.

mpg
#some cross-validation
   #set.seed(12345) #Sets certain so that predictions are the same for any user
   #let's avoid this for now, so we have random predictions
train<- mpg %>% 
  slice_sample(prop= .25)
test<- anti_join(mpg,train)

#the model
mod <- train %>% 
  glm(data= .,
      formula= cty ~ displ)

#predicting with test
test %>% 
  add_predictions(model = mod)
#now compare difference in predicted and actual values
test %>% 
  add_residuals(model = mod) %>% 
  pluck("resid") %>%  #Pluck will only show you the values in the vector you specify
  abs() %>% 
  mean()

#making a for-loop to run this 10 times
x<- list()

for(i in 1:10){
train<- mpg %>% 
  slice_sample(prop= .25)
test<- anti_join(mpg,train)


mod <- train %>% 
  glm(data= .,
      formula= cty ~ displ)


test %>% 
  add_predictions(model = mod)

x[[i]]<-test %>% 
  add_residuals(model = mod) %>% 
  pluck("resid") %>% 
  abs() %>% 
  mean()
}
#now it will show you 10 random samples predicted by the model
x %>% unlist()

data.frame(x=x %>% unlist()) %>% 
  ggplot(aes(x=x))+
  geom_density()


#now let's make it into a general function for any data set

x_val<- function(data=dat, n=100, form){
x<- list()

for(i in 1:n){
  train<- data %>% 
    slice_sample(prop= .25)
  test<- anti_join(data,train)
  
  
  mod <- train %>% 
    glm(data= .,
        formula= form)
  
  
  test %>% 
    add_predictions(model = mod)
  
  x[[i]]<-test %>% 
    add_residuals(model = mod) %>% 
    pluck("resid") %>% 
    abs() %>% 
    mean()
}

p<-data.frame(x=x %>% unlist()) %>% 
  ggplot(aes(x=x))+
  geom_density()
print(p)

#return(x %>% unlist())


}


#now let's see if this works
x_val(data=mpg, n=100, form= formula(cty ~ displ))
#you can also change the formula here and it will still work!
x_val(data=mpg, n=100, form= formula(cty ~ cyl + displ))

