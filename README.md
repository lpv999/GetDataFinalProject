Johns Hopkins / Coursera Data Science Specialization
Course: Getting and Cleaning Data
Final Project


Description of Script 'run_analysis.R':
====================================================
- Create HAR_Data directory with downloaded data and set as working directory

***
--> Test data set:

- Read test files into R: subject_test.txt -> test1, X_test -> test2, y_test -> test3
- Create new variable (obs, for number of observations) to act as key variable, append to each data frame, and change to descriptive variable names. New data frames: test1 -> subject_test, test2 -> measure_test, test3 -> act_test
- Check for missing values (NAs)
- Read activity_labels.txt file into R -> activity_labels. Add 'activity' variable (as factor) to act_test and assign descriptive activity Labels to each level
- Merge subject_test, measure_test, act_test into single data frame -> test_all

***
--> Train data set:

- Read train files into R: subject_train.txt -> train1, X_train -> train2, y_train -> train3
- Create new variable (obs, for number of observations, to act as key variable), append to each data frame, and change to descriptive variable names. New data frames: train1 -> subject_train, train2 -> measure_train, train3 -> act_train
- Check for missing values (NAs)
- Add 'activity' variable (as factor) to act_train and assign descriptive activity Labels to each level
- Merge subject_train, measure_train, act_train into single data frame -> train_all

***
--> Merge data sets:

- Merge test and train data sets into a single data frame: all_data
- Load dplyr package to manipulate data frames
- Convert all_data to tbl format and sort by subject -> allData_sorted

***
--> Extract Mean and Standard Deviation measurements from merged dataset:

- Read features.txt into R -> features
- Create a vector with variable names -> var_names
- Identify which variables are mean or standard deviation measurements, extract and sort into a new vector -> meanStd_index
- Use meanStd_index to extract variable labels from vector var_names -> meanStd_labels
- Column names from original dataset are designated with a V (V1, V2, V3...). To extract data from selected variables (before applying descriptive labels), create new vector of selected variables in same format by pasting V to column index vector -> meanStd_vars
- Add 'subject_id' and 'activity' labels to meanStd_vars -> newcolumns, and to meanStd_labels -> columnnames, to make the same length as merged dataset
- Extract data from merged dataset allData_sorted -> HAR_Data

***
--> Add descriptive variable names:

- Edit variable names -> new_colnames. Deleted all instances of '()', '-', and _ from labels. Also, took out extra 'Body' from last 9 variables, and capitalized Mean and Std.
- Create a data frame that shows correlation between original dataset's column names, provided feature names, and new variable names -> meanStd.variable.identifiers
- Apply new column names to HAR_Data

***
--> Create new tidy dataset with average values for each activity and each subject:

- Split HAR_data by activity. For each activity, group by subject and calculate mean of each variable. Includes a new variable 'nObs' which summarizes number of observations used to calculate mean for each variable. Resulting data frames: walking_avg, walkingUp_avg, walkingDown_avg, sitting_avg, standing_avg, and laying_avg
- Merge all 6 data frames into one -> HARdataAverages
- The new tidy dataset shows the average of each of the 79 measurements extracted from the original dataset for each activity by subject.
- Write HARdataAverages to text file -> HARdataAvg.txt
