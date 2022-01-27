list.files(path = "Data")
list.files(path = "Data",pattern = ".csv", full.names= TRUE)

#Don't forget to use # to write notes without it being added to the code
# <- is the assignment operator
#code output is on the right
#becomes the contents of the variable name to the left of <-
# :D 


csvfiles <- list.files(path = "Data",pattern = ".csv", full.names= TRUE)

csvfiles

csvfiles[1]

readLines(csvfiles[1])
#This is how you can recall items without knowing the names
#It is called a Vector
#Kind of like a list that are all the same type 

nums <- 1:10
nums + 1
nums2 <- nums/2
nums + 15
nums + (2 * 15)
nums + nums

#find all the files in Data/ that begin with "m" recursively

list.files(path="Data", 
           recursive= TRUE,
           full.names = TRUE,
           pattern = "^m")

#the ^ at the start of the "m" indicates that it is specifiying names that
#start with the letter m.

mfiles <- list.files(path="Data", 
                     recursive= TRUE,
                     full.names = TRUE,
                     pattern = "^m")

mush <- readLines(mfiles[11])

mush

mush <- read.csv(mfiles[11])


readLines("Data/Fake_grade_data.csv")

