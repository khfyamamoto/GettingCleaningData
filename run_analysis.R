#      Getting and Cleaning Data Programming Course Project
      
## 1. Merges the training and the test sets to create one data set.
#setwd("getcleandata/Assessments")

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_data <- rbind(x_train, x_test)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE) 
names(x_data) <- features[,2]
msdata <- x_data[,grep("mean|std", names(x_data), ignore.case=FALSE)]

## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
y_data <- rbind(y_train, y_test)
labels <- c()
for(i in 1:nrow(y_data)){
    labels[i] <- activity_labels[y_data[i,], 2]
}

## 4. Appropriately labels the data set with descriptive activity names.
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subid <- rbind(sub_train, sub_test)

dataset <- data.frame(subid, labels, msdata, stringsAsFactors = FALSE)
names(dataset)[1] <- "subject"

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
mdata <- aggregate(dataset[,3:ncol(dataset)], by=dataset[,1:2], FUN=mean)
library(reshape2)
tidydata <- melt(mdata, id=c("subject","labels"), measure.vars= names(mdata)[3:ncol(mdata)],
variable.name="features", value.name="mean")
write.table(tidydata, "tidydata.txt", quote=FALSE, row.names=FALSE, sep=",")
