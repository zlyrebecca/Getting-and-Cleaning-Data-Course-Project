
# Load activity labels & features
setwd("/Users/beccazhang/Desktop/Course/DS_4/datasets/")

#load datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#1. Merges the training and the test sets to create one data set
allData <- rbind(train, test)





#4. Appropriately labels the data set with descriptive variable names. 
features <- read.table("UCI HAR Dataset/features.txt") #column names of X_train.txt and X_test.txt
features <- as.character(features[,2])
features <- gsub("[()-]","", features)
# Make syntactically valid names out of character vectors.unique=TRUE, the resulting elements are unique. This may be desired for column names.
features_col <- make.names(features, unique=TRUE, allow_ = TRUE)
colnames(allData) <- c("subject", "activity", features_col)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
library(dplyr)
MeanStd <- select(allData, subject, activity, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2]) #convert factor to character
MeanStd$activity <- factor(MeanStd$activity, levels = activityLabels[,1], labels = activityLabels[,2])
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
MeanStd$subject <- as.factor(MeanStd$subject)
library(reshape2)
MeanStd.melted <- melt(MeanStd, id = c("subject", "activity"))
MeanStd.mean <- dcast(MeanStd.melted, subject + activity ~ variable, mean)

write.table(MeanStd.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
