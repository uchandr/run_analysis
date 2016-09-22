#Clean current workspace
rm(list=ls())
library(dplyr)
library(data.table)

#Extract the data files collected from the accelerometers 
#from the Samsung Galaxy S smartphone

#Retrieve Train data
x.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Retrieve Test data
x.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Read the features file
features <- read.table("UCI HAR Dataset/features.txt")

#Read the activity label file
activity.label <- read.table("UCI HAR Dataset/activity_labels.txt")

#Merge the training and test datasets
combined <- rbind(x.train,x.test)

#Get the column names for the train and test data
colnames(combined) <- features[,2]

#Extract only measurements for mean and std for each measurement

#Search for columns having 'mean' or 'std' and retrieve the index
reqcolumns <- grep(".*mean.*|.*std.*",colnames(combined))

#retrieve the column names for the corresponding index from the 'combined' data frame
reqcolnames <- colnames(combined[reqcolumns])
#remove "()" from column name
reqcolnames <- gsub('[()]', '',reqcolnames)

#extract and build a dataframe with column data having 'mean' and 'std'
i <- 1
meanstddata <- data.frame(combined[,reqcolumns[i]])

for (i in 2:length(reqcolumns))
{
  meanstddata <- cbind(meanstddata,data.frame(combined[,reqcolumns[i]]))
} 
colnames(meanstddata) <- reqcolnames


#combine activity and subject information to the measurement dataset

#Get the column names for activity label,activity id and subject id
colnames(activity.label) <- c("activityid", "activitylabel")
colnames(y.train) <- c("activityid")
colnames(y.test) <- c("activityid")
colnames(subject.train) <- c("subjectid")
colnames(subject.test) <- c("subjectid")

#1. Merge activity label and activity id dataframe by activity id.
#2. concatenate columns from dataframe created in 1 with subject dataframe 
#3. concatenate columns from 2 with 'combined. dataframe

datafinal <- merge(activity.label,rbind(y.train,y.test), by.x = "activityid") %>%
  cbind(rbind(subject.train,subject.test)) %>%
  cbind(meanstddata)

# Aggregate of each measurement by activity and subject id
datafinalDT <- data.table(datafinal)
aggregate.data <- datafinalDT[,lapply(.SD,mean), by = c("activityid","activitylabel","subjectid")]

#Write data to a text file
write.table(aggregate.data, "aggregated_data.txt",row.name=FALSE)
