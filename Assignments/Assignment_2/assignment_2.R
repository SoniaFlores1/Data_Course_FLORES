#Assignment 2
#Steps 1, 2 and 3 are done at this point.

#4. Find csv files
#You would need to go back a bit to get to data as follows.
list.files(path="../../Data", pattern=".csv", full.names=TRUE)

#../ means to go up one directory. Go back as many directories as you need.

getwd()

#Now store that list in an objected named "csv_files" 

csv_files<-list.files(path="../../Data", pattern=".csv", full.names=TRUE)

#5. find how many files match that description using length() fucntion
length(csv_files)

#6. open the wingspan_vs_mass csv files and store the contents as an R object named df
#using the read.csv() function

wvm<- list.files(path="../../Data/", pattern="wingspan_vs_mass.csv", full.names=TRUE)

read.csv(wvm)

df<- read.csv(wvm)
#to see the data class of object
class(df)
#to see the structure of object
str(df)
#or you can just click on the df play button in the environment to see the structure

#7. inspect the first 5 lines of data using head() function
head(df, n=5)


#8. find any files that start with the letter b (recursively)

list.files(path="../../Data/", 
           pattern="^b", 
           full.names=TRUE, recursive=TRUE)

bfiles<- list.files(path="../../Data/", 
                    pattern="^b", 
                    full.names=TRUE, recursive=TRUE)
bfiles

#9. write a command that displays the first line of the bfiles

readLines(bfiles[1])[1]

print(readLines(bfiles[1])[1])

readLines(bfiles[2])[1]

for (b in 1:3){
  print(readLines(bfiles[b])[1])
}


#10. Do the same things as above for all files that end in .csv
csv_files<-list.files(path="../../Data", 
                      pattern=".csv", 
                      full.names=TRUE, recursive=TRUE)

csv_files


for (i in 1:145){
  print(readLines(csv_files[i])[1])
}

