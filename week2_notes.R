#Find all .txt files in ./Data/ with full file paths
#save that list as an object named "txt_files"

list.files(path="Data", pattern=".txt", full.names=TRUE, recursive=TRUE)
txt_files<- list.files(path="Data", pattern=".txt", full.names=TRUE,
                       recursive=TRUE)
txt_files

#Now give only the first three of those files and call the list "first3"

first3<- txt_files[1:3]
#this is a character vector. The objects in this file are of the class "character"

first3

#new function: cancatinate (to stick together)
#c makes vectors 

c(1,3,5)

#You can use this to get elements 1, 3 and 5 from the txt files

txt_files[c(1,3,5)]

#give elements 1-10 and 15 of text files. (the first 10 elements and the 15th)

txt_files[c(1:10,15)]

#another way to do this

thestuffiwant<- c(1:10,15)

txt_files[thestuffiwant] #take the first 10 and the 15th element

#let's read in the first 3 files.

?readLines()

readLines(first3[1])

#you should see lots of DNA sequences.
#how do you see only the third line?

readLines(first3[1])[3]

#readLines is the function to read the lines in that file
#it will look at first3 and give the first files.
#from that output, now only the 3rd element will be given.

#Get the third line from the second file and third files as well

readLines(first3[1])[3]
readLines(first3[2])[3]
readLines(first3[3])[3]

#for-loop

for(i in 1:3){
  print(readLines(first3[i])[3])
}

c(1,3,5) + c(4,6,8)

#using past0 will stick together character items

x<- c("Billy", "Bob", "Jane")

paste0("My name is ", "Bob", ".")

for(i in x){
  print(paste0("My name is ",i, "."))
}

#You can feed a for loops any kind of vector
#This loops gives 3 lines where the names are changed in "My name is"

#review
#for-loop to add 5 to c(1,2,3)

c(1,2,3) + 5 #example without for-loop

#now with a for-loop

for(VARIABLENAME in LISTOFVALUES){
  #Do some stuff to VARIABLENAME
  #each time through, VARIABLENAME will take on the next value
}


for (i in 1:3){
  print(5+i)
}

#Now 5 will be added to 1, 2 and 3, making the values 6, 7, and 8.
#You might have to highlight the entire for-loop to run it.

#Load the wingspan_vs_mass.csv as an object called "df"
#Be sure to set your working directory or tell R to go back to that directory.

df<- read.csv("./Data/wingspan_vs_mass.csv")

#./ denotes that the file path starts "here." You can hit the dropdown key
#then you can see where your file is and click on it
#now that path is denoted.

#../ denotes "go back one." 
#You can explore around your computer with tab as well.
#especially while you are still earning how to navigate your repository
#Capitalization is very important, keep that in mind as you navigate.

class(df) #Tells me that the class of data is a data frame
dim(df) #tells me the dimensions of the object

#A small detour on numeric vs nominal values
c(1,2,3,"Bob")
c(1,2,3,"Bob") + 2
#The "Bob" makes the other values in this string into nominal data
# 2 can't be added to these values, unless you convert the nominal data to numeric
Bob<- 3
c(1,2,3,Bob) + 2

#You can try to use as.numeric to try to do this
as.numeric(c(1,2,3,"Bob"))
#But it won't work.
#However this can be used to convert certain columns or rows that you want
#to be read as numeric values.

#now back to work.

class(df) #Tells me that the class of data is a data frame
dim(df) #tells me the dimensions of the object. It is always read as rows then columns

#If you click on the little arrow next to df in the environment, you can see the data
#like an excel sheet, except you can't edit it directly.


#how would I find Row 5 and column 3 in this data frame?

df[5,3] #Row first, column second! X and then Y!
#you can verify if this number is correct by looking for this row and column yourself

df[5,] #gives only Row 5 and all associated columns with that row
#do not forget the comma, or it won't work!

df[,1] #gives only column 1 with all associated rows.
#But how do we view the names in the columns, not the numbers?

df[,"variety"]
#this is how we view the data under that column.

#what else can we do?
df[,c("variety","mass")]

#We can now see all the rows under both the "variety" and "mass" columns!
#This is because we cancanicated the "variety" and "mass" columns

#How do we view single columns? (shortcut)

df$variety

#using the $ sign will let you navigate the characters
#In this case, this vector has a length of 1000 and dimension of 1.

#calculate the momentum of the birds (momentum mass * velocity)

df$mass * df$velocity
#now you have momentum values of these birds

df$momentum

#this doesn't exist yet, so we make it exist

df$momentum<- df$mass * df$velocity

#now the column "momentum" exists in the data saved in the object "df"

df$test <- "oops"
df$test <- c("oops","oh yeah")
#cancatinating these two will recycle these vectors. Be very careful with this.
#for some reason, it can only do two. This is kinda stupid behavior for R.
#seriously what is this???

#how do we get rid of the "test" column?

df$test<-NULL
#Now that column will no longer exist.

TRUE #true
FALSE #false
NA #missing
NULL #does not exist

#all these commands are very important and distinct from one another
#and will do very different things

#expressions (logical)

1 > 3
#R will tell me this is FALSE

3>=3
#R will tell me this is true

"bob" == "bob" # the == means "is equal to"
#R tells me this is true

"billy" != "bob" # the != means "is not equal to"
#R tells me this is true

3 < 5
#Also true

#this is how we ask R for TRUE/FALSE questions. This is one one way, at least.

1 > FALSE
#true
TRUE>FALSE
#True
TRUE> 1
#False
NA>1
#NA
1+NA
#NA
NULL+1
#gives us numeric 0. 

1 %in% 2:3 #is the thing of the left found in the thing on the right?
1 %in% 1:10
1:3 %in% 1:10
1:20 %in% 1:10

3>2 & 3<10 #this is for and

3>2 | 3>0 #this is for or



#Let's apply this concept of logical expressions to our data.
#we'll use this to find a certain kind of data.

df$momentum > 2000
#in the "momentum" column, now we are looking at which values are greater than 2000

momentous<- df$momentum > 2000

which(momentous == TRUE)
#tells us which birds have momentums greater than 2000

df[momentous,]
#shows use the associated data of the brids with momentums greater than 2000

dim(df[momentous,])
#gives us the dimensions of this data. We have 31 birds with over 2000 momentum

df2<- df[momentous,]
#Now you have an object that contains only birds whose momentums are larger than 2000

#Bonus (base plotting)
plot(x=df$mass,y=df$momentum)

#You can use this plot function to make a graph, but you must give it X and Y.
#This plot shows that as mass increases, so does momentum

plot(x=df$variety,y=df$momentum)
#This plot gives an error, because df variety is not a numeric value it can use.
#df momentum is numerical. 
#we can assign variety as a factor to make a boxplot instead.

plot(x=as.factor(df$variety),y=df$momentum)
#Now we have a boxplot comparing momentums of the two varieties of birds
#Not that we didn't actually use the boxplot function.
#as.factor treats the value as a different vector


#For Week 3 we will learn more about operators, vectors, and other things.

#Do the practice!!!! It will help you, future Sonia!!!!!!!!!!!!!!!!!

