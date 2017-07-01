#### ADS Program - S Summers ####
#### Getting and Cleaning Data Final Project
#### You should create one R script called run_analysis.R that does the following:

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Good luck!

setwd("/Users/Sean/Documents/R Files/ZS ADS/02 Getting and Cleaning Data/04 Week 4/02 W4 Assignment/UCI HAR Dataset/All Data")

#### Read and Format Subject ID Data ####
testSubjects <- read.table("subject_test.txt", header = FALSE, stringsAsFactors = FALSE)
names(testSubjects) <- "SubjectID"

trainSubjects <- read.table("subject_train.txt", header = FALSE, stringsAsFactors = FALSE)
names(trainSubjects) <- "SubjectID"

#### Reads in Column Names and Manipulates so Unique ####
features <- read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)
features$V3 <- paste(features$V1,features$V2) 

#### Read and Format Test Data ####
testX <- read.table("X_test.txt", header = FALSE, stringsAsFactors = FALSE)
testY <- read.table("y_test.txt", header = FALSE, stringsAsFactors = FALSE)
names(testX) <- (paste(features$V3))
names(testY) <- "activityLabels"

testFullData <- data.table(testSubjects,GroupFlag = "Test",testY,testX)
## Generates consolidated data table for subjects, adding Flag to 
## indicate they belong to the 'Test' group

#### Read and Format Train Data ####
trainX <- read.table("X_train.txt", header = FALSE, stringsAsFactors = FALSE)
trainY <- read.table("y_train.txt", header = FALSE, stringsAsFactors = FALSE)
names(trainX) <- (paste(features$V3))
names(trainY) <- "activityLabels"

trainFullData <- data.table(trainSubjects,GroupFlag = "Train", trainY,trainX)
## Generates consolidated data table for subjects, adding Flag to 
## indicate they belong to the 'Train' group

#### Generates Full Data Set from Test and Train Data  ####
fullActivityDataSet <- merge(trainFullData,testFullData, all = TRUE)

#### Subsets Columns with Mean and STDEVIATION ####

meanStdColList <- fullActivityDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(meanStdColList) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

fullActivityDataSet <- data.frame(fullActivityDataSet)
fullActivityDataSetSTDMEAN <- fullActivityDataSet[,xDataSet_mean_std]

#### Renames Columns ####

names(fullActivityDataSetSTDMEAN) <- make.names(names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('Acc',"Acceleration",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('GyroJerk',"AngularAcceleration",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('Gyro',"AngularSpeed",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('Mag',"Magnitude",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('^t',"TimeDomain.",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('^f',"FrequencyDomain.",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('\\.mean',".Mean",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('\\.std',".StandardDeviation",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('Freq\\.',"Frequency.",names(fullActivityDataSetSTDMEAN))
names(fullActivityDataSetSTDMEAN) <- gsub('Freq$',"Frequency",names(fullActivityDataSetSTDMEAN))

#### Generates Single Tidy Data Set ####
SummaryData<-aggregate(. ~SubjectID + GroupFlag + activityLabels, fullActivityDataSetSTDMEAN, mean)
write.table(SummaryData, file = "tidydata.txt",row.name=FALSE)

