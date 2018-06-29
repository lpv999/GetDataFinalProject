# download UCI HAR Dataset (zip file) from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# save to new directory HAR_Data
dir.create("~/DataScience/HAR_Data")
dateDownloaded <- date()

HAR <- "~/DataScience/HAR_Data"
setwd(HAR) # set working directory

## READ TEST FILES INTO R
test1 <- read.table("./test/subject_test.txt") # subject file
test2 <- read.table("./test/X_test.txt") # measurements file
test3 <- read.table("./test/y_test.txt") # activity file

# add variable in common (obs, for observation) to all three dataframes to join
obs <- c(1:2947)
subject_test <- cbind(obs, test1) # add obs to subjects dataframe --> subject_test
colnames(subject_test) <- c("obs", "subject_id") # change variable names

measure_test <- cbind(obs, test2) # add obs variable to measurements dataframe --> measure_test
m_test_na <- sum(is.na(measure_test)) # check for missing values (NAs)

act_test <- cbind(obs, test3) # add obs variable to activity dataframe --> act_test
colnames(act_test) <- c("obs", "act_id")
activity_labels <- read.table("./activity_labels.txt") # read activity labels
act_test$activity <- factor(act_test$act_id) # add activity variable (factor) with labels
levels(act_test$activity) <- c("walking", "walking_up", "walking_down", "sitting", "standing", "laying")

# join test dataframes
s_a_test <- merge(subject_test, act_test)
test_all <- merge(s_a_test, measure_test)

## READ TRAIN FILES INTO R
train1 <- read.table("./train/subject_train.txt")
train2 <- read.table("./train/X_train.txt")
train3 <- read.table("./train/y_train.txt")

# add variable in common (obs, for observation) to all three dataframes to join
obs <- c(1:7352)
subject_train <- cbind(obs, train1) # add obs to subjects dataframe --> subject_train
colnames(subject_train) <- c("obs", "subject_id") # change variable names

measure_train <- cbind(obs, train2) # add obs variable to measurements dataframe --> measure_train
m_train_na <- sum(is.na(measure_train)) # check for missing values (NAs)

act_train <- cbind(obs, train3) # add obs variable to activity dataframe --> act_train
colnames(act_train) <- c("obs", "act_id")
act_train$activity <- factor(act_train$act_id) # add activity variable (factor) with labels
levels(act_train$activity) <- c("walking", "walking_up", "walking_down", "sitting", "standing", "laying")

# join train dataframes
s_a_train <- merge(subject_train, act_train)
train_all <- merge(s_a_train, measure_train)

## MERGE TEST AND TRAIN DATASETS
all_data <- rbind(train_all, test_all)

# load dplyr package and convert dataframe into tbl format
library(dplyr)
allData_tbl <- tbl_df(all_data)
allData_sorted <- arrange(allData_tbl, subject_id)  # sort dataframe by subject_id

## EXTRACT MEAN & STD VARIABLES FROM DATASET
features <- read.table("features.txt", stringsAsFactors = FALSE) # read variable label file
var_names <- as.vector(features$V2) 

# identify which variables are mean or std measurements
mean_vars <- grep("mean", var_names)
std_vars <- grep("std", var_names)

# combine mean and std indices into one vector 
meanStd <- c(mean_vars, std_vars)  
meanStd_index <- sort(meanStd) # sort variable indices
meanStd_labels <- var_names[meanStd_index]  # extract variable labels 
meanStd_vars <- paste("V", meanStd_index, sep = "") # paste "V" to variable indices to extract columns

newcolumns <- c("subject_id", "activity", meanStd_vars) # add subject_id and activity labels to extracted variables
columnnames <- c("subject_id", "activity", meanStd_labels) # add subject_id and activity labels to column labels

# extract subset of data using mean and std variables using newcolumns ("subject_id", "activity", V1:V81)
HAR_data <- select(allData_sorted, newcolumns)

# edit coluumnnames
edit1 <- gsub("[()]", "", columnnames)
edit2 <- gsub("-","", edit1)
edit3 <- gsub("_id", "", edit2)
edit4 <- gsub("BodyBody", "Body", edit3)
edit5 <- gsub("mean", "Mean", edit4)
new_colnames<- gsub("std", "Std", edit5)


meanStd.variable.identifiers <- data_frame(colIndex=meanStd_index, Vnumber=meanStd_vars, featureName=meanStd_labels, newVariableName=new_colnames[3:81]) 
# creates dataframe showing correlation between original column indices (colIndex), labels in original dataset (Vnumber), 
        # feature names (featureName), and new variable names (newVariableName)

#add new variable names to HAR_data
colnames(HAR_data) <- new_colnames
View(HAR_data)

## CREATE NEW TIDY DATASET with average values
# calculate average of each variable for each activity by subject

# split HAR_data by activity. For each, group by subject and calculate mean of each variable
# include variable nObs for number of observations used to calculate mean
walking <- filter(HAR_data, activity == "walking")
walking_avg <- walking %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject,activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "walking")

walkingUp <- filter(HAR_data, activity == "walking_up")
walkingUp_avg <- walkingUp %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject,activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "walkingUp")

walkingDown <- filter(HAR_data, activity == "walking_down")
walkingDown_avg <- walkingDown %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject,activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "walkingDown")

sitting <- filter(HAR_data, activity == "sitting")
sitting_avg <- sitting %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject, activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "sitting")

standing <- filter(HAR_data, activity == "standing")
standing_avg <- standing %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject, activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "standing")

laying <- filter(HAR_data, activity == "laying")
laying_avg <- laying %>% 
        group_by(subject)  %>% 
        mutate(nObs=n()) %>% 
        select(subject, activity, nObs, tBodyAccMeanX:fBodyGyroJerkMagMeanFreq) %>% 
        summarize_all(mean) %>%
        mutate(activity = "laying")

# merge all into a single dataset
HARdataAverages <- rbind(walking_avg, walkingUp_avg, walkingDown_avg, sitting_avg, standing_avg, laying_avg)

write.table(HARdataAverages, "HARdataAvg.txt", row.names=FALSE) # save as text file

