    # Download the data
    if (!file.exists("./data")) 
    {
        dir.create("./data")
    }
    
    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    download.file(data_url, destfile = "./data/week4_data.zip")
    
    unzip("./data/week4_data.zip", exdir = "./data")
    
    # Raw data ready for work
    
    ## Reads test data
    test <- cbind(read.fwf("./data/UCI HAR Dataset/test/subject_test.txt", widths = 1, colClasses = "integer"), 
                  read.fwf("./data/UCI HAR Dataset/test/Y_test.txt", widths = 1, colClasses = "integer"), 
                  read.fwf("./data/UCI HAR Dataset/test/X_test.txt", widths = rep.int(16, 561), colClasses = "numeric", buffersize = 25000))
    
    ## Reads train data
    train <- cbind(read.fwf("./data/UCI HAR Dataset/train/subject_train.txt", widths = 1, colClasses = "integer"), 
                  read.fwf("./data/UCI HAR Dataset/train/Y_train.txt", widths = 1, colClasses = "integer"), 
                  read.fwf("./data/UCI HAR Dataset/train/X_train.txt", widths = rep.int(16, 561), colClasses = "numeric", buffersize = 25000))
    
    ## Merges train and test to one data set and remove temporary objects "test" and "train" from R session
    dataset <- rbind(test, train)
    rm("test")
    rm("train")
    
    # Sets names for data set variables
    
    ## Reads features names
    features <- read.delim("./data/UCI HAR Dataset/features.txt", header = FALSE, sep = ' ', stringsAsFactors = FALSE)
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
    activities <- read.delim("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = ' ')
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
    
    write.csv(dataset, file = "./data/tidyDataset.csv", row.names = FALSE)
    write.csv(averageDataSet, file = "./data/averageDataset.csv", row.names = FALSE)