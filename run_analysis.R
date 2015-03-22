#############
# run_analysis.R
#############
# install and load packages
install.packages('plyr')
library(plyr)

# download and load the data

URL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(URL, destfile="Smartphone.zip",method='curl')
unzip("Smartphone.zip", exdir='Smartphone')
rm(URL)

##### load general files
setwd('./UCI HAR Dataset')
files <- c(dir()[1], dir()[3])
for (i in seq_along(files)) {
  assign(files[i], read.table(files[i], as.is=TRUE))
}
rm(files, i)

##### load test files
setwd('./test')
files <- list.files(pattern = ".txt")
for (i in seq_along(files)) {
  assign(files[i], read.table(files[i], as.is=TRUE))
}
rm(files, i)

##### load test files
setwd('../train')
files <- list.files(pattern = ".txt")
for (i in seq_along(files)) {
  assign(files[i], read.table(files[i], as.is=TRUE))
}
rm(files, i)

# y_test.txt: it's a column that describes the activity
# subject_test.txt: it's a column that describes which person is performng the activity
# X_test.txt: data

#### Organize the test dataframe
names(X_test.txt) <- features.txt[,2]
Test <- data.frame(Subject=subject_test.txt$V1, Activity=y_test.txt$V1, X_test.txt)

#### Organize the train dataframe
names(X_train.txt) <- features.txt[,2]
Train <- data.frame(Subject=subject_train.txt$V1, Activity=y_train.txt$V1, X_train.txt)

#### combine test and train
CombData <- rbind(Train, Test)

##### 
# extract only the mean and the stdev columns
Mean <- grep('mean\\.|std', names(CombData), value=TRUE)
CombData_mean_sd <- CombData[,c('Subject', 'Activity', Mean)]

#####
# Use descriptive activity names to name the activities in the data set
NamesActivities <- activity_labels.txt[,2] [CombData_mean_sd$Activity]
CombData_act <- transform(CombData_mean_sd, Activity= NamesActivities) 
rm(NamesActivities)
##### 
# Appropriately labels the data set with descriptive variable names
a <- names(CombData_act)
b <- gsub('\\.\\.$', '', a)
b <- gsub('\\.+', '_', b)
names(CombData_act) <- b
rm(a, b)

##### 
# creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData <- aggregate(CombData_act[,3: ncol(CombData_act)], by=list(Subject=CombData_act$Subject, Activity=CombData_act$Activity), FUN='mean', simplify=TRUE)
TidyData <- arrange(D, Subject, Activity)

setwd('../')
write.table(TidyData, file='TidyData.txt',row.name=FALSE, sep='\t')

