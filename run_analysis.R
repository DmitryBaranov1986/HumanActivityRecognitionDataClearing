library(dplyr)

# Download the data
if (!file.exists("./GettingAndClearingAssigmentData")) 
{
    dir.create("./GettingAndClearingAssigmentData")
}

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(data_url, destfile = "./GettingAndClearingAssigmentData/uci_har_dataset.zip")

unzip("./GettingAndClearingAssigmentData/uci_har_dataset.zip", exdir = "./GettingAndClearingAssigmentData")

# Raw data ready for work

## Reads test data
test <- cbind(read.table("./GettingAndClearingAssigmentData/UCI HAR Dataset/test/subject_test.txt"), 
              read.table("./GettingAndClearingAssigmentData/UCI HAR Dataset/test/Y_test.txt"), 
              read.fwf("./GettingAndClearingAssigmentData/UCI HAR Dataset/test/X_test.txt", widths = rep.int(16, 561), colClasses = "numeric", buffersize = 25000))

## Reads train data
train <- cbind(read.table("./GettingAndClearingAssigmentData/UCI HAR Dataset/train/subject_train.txt"), 
               read.table("./GettingAndClearingAssigmentData/UCI HAR Dataset/train/Y_train.txt"), 
              read.fwf("./GettingAndClearingAssigmentData/UCI HAR Dataset/train/X_train.txt", widths = rep.int(16, 561), colClasses = "numeric", buffersize = 25000))

## Merges train and test to one data set and remove temporary objects "test" and "train" from R session
dataset <- rbind(test, train)
rm("test")
rm("train")

# Sets names for data set variables

## Reads features names
features <- read.delim("./GettingAndClearingAssigmentData/UCI HAR Dataset/features.txt", header = FALSE, sep = ' ', stringsAsFactors = FALSE)
features <- features[,2]

## Names dataset
names(dataset) <- c("subject", "activity", features)

# Extracts only the measurements on the mean and standard deviation

## Find variables indices which has "mean" or "std" in their names, also keep "activity" and "subject" variables
idx <- grep("(.+mean.+)|(.+std.+)|activity|subject", names(dataset))
dataset <- dataset[,idx]
rm("idx")

## Cleans data set variables names
names(dataset) <- gsub("[^[:alnum:]]", "", gsub("std", "Std", gsub("mean", "Mean", names(dataset))))

# Sets activities names
dataset <- tbl_df(dataset)

## Reads activities name
activities <- read.delim("./GettingAndClearingAssigmentData/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = ' ')
activities <- activities[,2]

## Sets names
dataset <- mutate(dataset, activity = activities[activity])

rm("activities")
rm("features")
rm("data_url")
# Data is cleaned

# Creates average of each variable for each activity and each subject
averageDataSet <- dataset %>% group_by(subject, activity) %>% summarise_all(mean)

# Export tidy data

write.table(dataset, file = "./GettingAndClearingAssigmentData/tidyDataset.txt", sep = "\t", row.names = FALSE, fileEncoding = "UTF-8")
write.table(averageDataSet, file = "./GettingAndClearingAssigmentData/averageDataset.txt", sep = "\t", row.names = FALSE, fileEncoding = "UTF-8")
