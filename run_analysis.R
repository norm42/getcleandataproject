## This script reads in the test and training files then merges them.
## for each file the header is read and used as the "names" for the data frames
## header is modified to remove (), ., -
## then grep is used to find headers/columns that are mean or std values
## the data frames are subsetted to only have the mean/avg columns
## the test and training data frames are merged into one
## note that we do not need to process the raw data at all given the requirements for the 
## project
## 
##  Norm Zeck
##  For Coursera Getting and Cleaning Data
##  May 2014
##
## read in test data file and column names
##
dataDirectory <- "UCI HAR Dataset"
if(!file.exists(dataDirectory)) {
  stop("Data Directory: UCI HAR Dataset does not exist")
}
xtestData <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses = "double")
##
## Read in header file and make into nicer to use variable headers
##
x1header <- read.table("UCI HAR Dataset/features.txt", colClasses = "character")
tc <- gsub("\\(\\)", "", x1header$V2)  ## get rid of double parens
tc1 <- gsub("-", ".", tc)  ## get rid of dashes
## tc2 <- gsub("\\.", "", tc1)  ## sample to remove "." if desired
tc2 <- tolower(tc1)   ## make all lowercase
names(xtestData) <- tc2
##
## read in subject test file.  This containes numeric subject designations 1-30
##
subtestfile <- "UCI HAR Dataset/test/subject_test.txt"
subjecttestData <- read.table(subtestfile, colClasses = "integer")
names(subjecttestData) <- "Subject"
##
## initialize activity names
##
actName <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
## read in the activity number
acttestfile <- "UCI HAR Dataset/test/y_test.txt"
activitytestData <- read.table(acttestfile, colClasses = "integer")
names(activitytestData) <- "Activity"
##
## Substitute in the activity name for the number
##
numTestrows <- nrow(activitytestData)   ## number of rows to substitute
acttestName <- vector(mode="character", length=numTestrows)  ## allocate test name vector
## loop though all the activity indexes and substitute in the names
for(i in 1:numTestrows){
  acttestName[i] <- actName[activitytestData$Activity[i]]
}

## Merge in the subject, activity, and test data
tmpdf <- data.frame(subjecttestData, Activity=acttestName, xtestData)
## use grep to get only the mean and std columns
c2 <- c(1:2, grep("mean", colnames(tmpdf)), grep("Mean", colnames(tmpdf)), grep("std", colnames(tmpdf)))
c3 <- sort(c2)
xtestMeanStd <- tmpdf[, c3]   # this has the test data for only mean/std

## Basically do the same for teh training data
## read in test data file and column names
##
xtrainData <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "double")
## x1header <- read.table("UCI HAR Dataset/features.txt", colClasses = "character")
names(xtrainData) <- tc2
## read in subject train file
subtrainfile <- "UCI HAR Dataset/train/subject_train.txt"
subjecttrainData <- read.table(subtrainfile, colClasses = "integer")
names(subjecttrainData) <- "Subject"
## read in the activity number
acttrainfile <- "UCI HAR Dataset/train/y_train.txt"
activitytrainData <- read.table(acttrainfile, colClasses = "integer")
names(activitytrainData) <- "Activity"

## substisute in the activity names
numTrainrows <- nrow(activitytrainData)

acttrainName <- vector(mode="character", length=numTrainrows)
for(i in 1:numTrainrows){
  acttrainName[i] <- actName[activitytrainData$Activity[i]]
}

## merge in subject, activity, training data
tmpdf <- data.frame(subjecttrainData, Activity=acttrainName, xtrainData)
## select only mean/std
c2t <- c(1:2, grep("mean", colnames(tmpdf)), grep("Mean", colnames(tmpdf)), grep("std", colnames(tmpdf)))
c3t <- sort(c2t)
xtrainMeanStd <- tmpdf[, c3t]
## merge in training and test data sets
xtraintestData <- rbind(xtrainMeanStd, xtestMeanStd)
## Order by subject
## xtraintestDataFinal has the merged in data from both sets only mean/std columns
xtraintestDataFinal <- xtraintestData[order(xtraintestData$Subject, xtraintestData$Activity ),  ]
##
##  This part of the script calcualtes the mean (average) of the 
##  data set that now contains only mean and standard deviation samples.
##  This is part of the requirements for part 5 of the project
##  The second script "makenormstidy.R" complets the generation of the 
##  Tidy data set
## 
##  Norm Zeck
##  For Coursera Getting and Cleaning Data
##  May 2014
##
##  We will generate the mean for each subject, for each actiity.  This will yield
##  6 mean values sets of 88 variables (filterd by mean/std dev) for each subject  
##  We then compute the mean for each activity.  This generates another 6 total rows for
##  the 88 variables.
endvar <- ncol(xtraintestDataFinal)    ## number of columns to average  
numsub <- unique(xtraintestDataFinal[,"Subject"])  ## get number of unique sujects
##  need the activity names to subset by activity
actName <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
k <- 1  ## index variable

## avgdf <- data.frame()
avglist <- list()  ## init list used to save the subject averages
for(i in 1:length(numsub)) {
  tmp1 <- subset(xtraintestDataFinal, Subject == numsub[i])  ##  subset subject
  for(j in 1:length(actName)) {
    tmp2 <- subset(tmp1, Activity == actName[j])  # subset activity for a subject
    tmp3 <- colMeans(tmp2[3:endvar])  # calc mean
    avglist[[k]] <- c(i, actName[j], tmp3)   ##  save in a list 
    k <- k + 1  ## increment list counter
  }
}
## avglist contains the averages for each subject for each activity
avgsubdf <- as.data.frame(do.call("rbind", avglist))  ## make into a data frame
names(avgsubdf) <- names(xtraintestDataFinal)  ##  update names to be the same as original
##
## Calc avg for each activity 
##
endvar <- ncol(xtraintestDataFinal)
actName <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
k <- 1  ## index variable

## avgdf <- data.frame()
avglist <- list()  ## init list
for(i in 1:length(actName)) {
  tmp1 <- subset(xtraintestDataFinal, Activity == actName[i])  ##  subset activity for all subjects
  tmp2 <- colMeans(tmp1[3:endvar])  # calc mean
  avglist[[k]] <- c("All", actName[i], tmp2)  ## save in list
  k <- k + 1  ## increment index
}
##  avgdfact is the data frame that contains the average of each activity
avgdfact <- as.data.frame(do.call("rbind", avglist))
names(avgdfact) <- names(xtraintestDataFinal)  ## update names to original
## Merge in the two data frames
## This data frame will now have averages for each suject for each activity 6 per subject
## and 6 additonal averages of activity for all subjects
avgall <- rbind(avgsubdf, avgdfact)  ## merge in the two data frames subject and activity



