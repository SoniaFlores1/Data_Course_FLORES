fn1 <- function(x){
  z <- x^2
  return(z)
}
fn1(2)



fn_pythag <- function(A,B){
  C <- sqrt(A^2 + B^2)
  return(C)
}
fn_pythag(3,3)
my_hyp <- fn_pythag(A = 5,B = 10)

my_hyp


fn_pythag(A=c(1,2,3),B=c(3,4,5))



fn2 <- function(x,y,z){
  if(!is.numeric(x) | !is.numeric(y) | !is.numeric(z)){
    stop("Hey. x y and z all need to be numeric")
  }
  
  j <- sum(x,y,z)
  return(j)
}



fn2("2",3,"4")


library(modelr)
library(tidyverse)



# set.seed(12345)

x_val <- function(data=dat,n=100,form){
  x <- list()
  
  
  
  for(i in 1:n){
    train <- data %>% 
      slice_sample(prop = .25)
    test <- anti_join(data,train)
    
    
    
    mod <- train %>% 
      glm(data = .,
          formula = form)
    
    
    
    x[[i]] <- test %>% 
      add_residuals(model = mod) %>% 
      pluck("resid") %>% 
      abs() %>% 
      mean()
  }
  
  
  
  p <- data.frame(x=x %>% unlist()) %>% 
    ggplot(aes(x=x)) +
    geom_density()
  
  
  
  print(p)
  # return(x %>% unlist())
  
  
  
}



x_val(data = mpg,n = 100,form = formula(cty ~ displ))
x_val(data = mpg,n = 100,form = formula(cty ~ cyl + displ))




data.frame(x=x %>% unlist()) %>% 
  ggplot(aes(x=x)) +
  geom_density()



#And here's another function to look at for practice reading these things:
# Can you figure out what this function does?
# What requirements does it have (inputs, classes, dependencies, etc)?
# can you get it to work on the iris data set?

my_function <- function(data,seed=123,colname){
  # check dependencies
  packages = c("tidyverse", "patchwork")
  package.check <- lapply(
    packages,
    FUN = function(x) {
      if (!require(x, character.only = TRUE)) {
        install.packages(x, dependencies = TRUE)
        library(x, character.only = TRUE)
      }
    }
  )
  # check class requirements
  if(!is.data.frame(data)){
    stop("data must be a data frame")
  }
  if(!is.character(colname) | length(colname) != 1){
    stop("colname must be a character vector of length 1")
  }
  if(!colname %in% names(data)){
    stop("colname must be present in data")
  }
  if(data %>% pluck(colname) %>% class() != "numeric"){
    stop("colname must refer to a numeric column")
  }
  # do some stuff
  set.seed(seed)  
  split_1 <- data %>% 
    slice_sample(prop = .5)
  split_2 <- anti_join(data,split_1)
  split_1 <- arrange(split_1,get(colname))
  split_2 <- arrange(split_2,get(colname))
  p1 <- ggplot(split_1, aes(x=seq_along(row.names(split_1)),
                            y=get(colname))) +
    geom_point() +labs(title="Split 1",x="",y=colname)
  p2 <- ggplot(split_2, aes(x=seq_along(row.names(split_2)),
                            y=get(colname))) +
    geom_point() +labs(title="Split 2",x="",y=colname)
  
  p3 <- p1 + p2
  print(p3)
}
