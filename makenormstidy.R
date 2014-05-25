## 
##  Norm Zeck
##  For Coursera Getting and Cleaning Data
##  May 2014
##
## this script reads creates a melt of the averaged data set generated from the script
## run_analysis.R (which needs to run before this script)
## then the data file that has the mapping for each of the 88 original variables to the 
## new variable names.  The for loop then subsets the meld on the original variable name
## then generates a new row for that variable name with the new variables and the sample.
##
namesfile <- "normstidynames.csv"
if(!file.exists(namesfile)) {
  stop("Names file: normstidynames.csv does not exist")
}
library(reshape2)  ## need this for meld
## generate a meld that will have 
##  Subject, Activity, Sample variable name, Sample value
## warning comes up due to attributes are not identical across measure variables
options(warn = -1) 
avgmelt<- melt(avgall, id.vars = c("Subject", "Activity")) 
options(warn = 0)
## read in file that has the mapping to new variable names
tidyhead <- read.csv("normstidynames.csv")
## number of rows are the original sample titles to map to new tidy set
numvars <- nrow(tidyhead)  
normstidydf <- data.frame()  ## init data frame
## warning comes up due to headers not the same which is added as a separate step
## there is probably a way to order the names so there is no issue
## options(warn = -1)  
for(i in 1:numvars){
  ## subset off one of the original variable names
  tmpt1 <- subset(avgmelt, variable == as.character(tidyhead$ID[i]))
  ## generate a new row that has the new variable names
  tidyrow <- tidyhead[i,][2:ncol(tidyhead)]
  ## there are nrow samples of the original variable name
  ## we need to replicate the new variables for all the samples
  numRowThisID <- nrow(tmpt1)  ## number of samples 
  tlist <- list()  ## init list to build the full set of rows
  for(j in 1:numRowThisID) {
    tlist[[j]] <- tidyrow   ## replicate the rows for the number of samples
  }
  tidydf <- as.data.frame(do.call("rbind", tlist))  ## make into a data frame
  ## add in subject, activity and value
  dtmp <- data.frame(tmpt1$Subject, tmpt1$Activity, tidydf, tmpt1$value)  
  colnames(dtmp)[1] <- "Subject"
  colnames(dtmp)[2] <- "Activity"
  colnames(dtmp)[10] <- "Mean Value"
  normstidydf <- rbind(normstidydf, dtmp)  ## update data frame with tidy format for a sample set
}
## order the data set by subject and activity.  This will still leave the old index if 
## it is desired to sort by original variable
normstidydf <- normstidydf[order(normstidydf$Subject, normstidydf$Activity ),  ]
## 
## normstidydf now contains the tidy data frame
## will write this out in two formats: csv and tab delimited
write.csv(normstidydf, "normstidydf.csv", row.names=FALSE)
write.table(normstidydf, "normstidydf.txt", row.names=FALSE, sep = "\t")
  
