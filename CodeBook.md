## Data processing 
+ Read test data: join following input files to _test_ data.frame by lines
  - 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample
  - 'test/Y_test.txt': Test labels
  - 'test/X_test.txt': Test set
+ Read train data: join following input files to _train_ data.frame by lines
  - 'ttrain/subject_train.txt': Each row identifies the subject who performed the activity for each window sample
  - 'train/Y_train.txt': Training labels
  - 'train/X_train.txt': Training set
+ Meagre _test_ and _train_ data.frames into _dataset_ data.frame
+ Read features names from 'features.txt' file
+ Set names for _dataset_: first - 'subject', second - 'activity', the rest are from features names
+ Reduce _dataset_ columns quantity by getting columns 'subject', 'activity' and columns which name contains literals 'mean' or 'std'
+ Read activities names from 'activity_labels.txt' file to _activities_
+ Mutate _dataset_ set value to column 'activity' from _activities_ by row number is equal to 'activity' value
+ *Tidy dataset ready*
+ Group tidy _dataset_ by 'subject' and 'activity'
+ Summirise all columns (except groupped) with mean calculation
+ *The dataset of average values ready*
+ Write tidy _dataset_ to 'tidyDataset.txt' file
+ Write dataset of average value to 'averageDataset.txt' file

## Tidy dataset 'tidyDataset.txt'
The output file contains eighty one fields. This table provides each experiment mean and standard deviation measurements (described in original data source) for subject per activity.
1. Subject: integer. Identifier of the subject who performed the activity.
2. Activity: char. Label of performed activity by the subject.

The rest columns are mean and standard deviation measurements which described in original source.

## Average tidy dataset measurements 'averageDataset.txt'
The output file contains eighty one fields. This table provides an average value of mean and standard deviation measurements (described in original data source) groupped by subject and activity.
1. Subject: integer. Identifier of the subject who performed the activity.
2. Activity: char. Label of performed activity by the subject.

The rest columns are mean and standard deviation measurements which described in original source.
