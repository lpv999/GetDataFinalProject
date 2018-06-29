Johns Hopkins / Coursera Data Science Specialization
Course: Getting and Cleaning Data
Final Project Code Book


Dataset:  UCI HAR Dataset downloaded from
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
on June 25, 2018
======================================

Original Dataset included the following files:
=========================================
- 'README.txt': describes dataset
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features (name of the measurements taken).
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_train.txt': identifies the subject who performed the activity for each window sample.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_test.txt': identifies the subject who performed the activity for each window sample.

Assignment:
=================================================
1. Merge training and test datasets into a single tidy dataset
2. Extract variables for the mean and standard deviation of each measurement
3. Use descriptive activity names to name the activities in the dataset
4. Labels the data set with descriptive variable names
5. Create a second tidy dataset with the average of each variable for each activity and each subject

Data Description and Transformation
====================================================
(1) Merging datasets, and (3) Using descriptive activity names in dataset

To tidy the data and produce the second dataset, I used the accompanying run_analyis.R script. Step by step details of how the script works are provided in the README.md file

The following is a general description of the data and the transformations that took place.

The data was provided in two parts:  a dataset for a 'test' group (9 subjects), and a second dataset for a 'train' group (21 subjects).

Each dataset was comprised of three text files: a vector identifying the subject (subject_test, subject_train ), the measurements (X_test, X_train), and a vector identifying the activity being measured (y_test, y_train).

The measurement files record values for 561 different variables described in the features_info.txt file and listed in the vector file features.txt. But the measurement files lack labels for the variables. Instead, each column is designated with a V and the column number (e.g., V1, V2, V3).

The test dataset has 2947 observations, while the train dataset has 7352 observations.

To tidy the dataset, the three files for each group had to be joined first to put together the subject, activity, and measurements data. To do this, each file had to have a key variable in common, so a numeric vector ('obs', for number of observations) was created for this purpose.

For the activity files, the activity labels (obtained from the activity_labels text file) were used to replace the numeric codes. So 1 became "walking", 2, became "walking_up" (short for walking_upstairs), 3 became "walking_down"(short for walking_downstairs), 4 became 'sitting', 5 became 'standing', and 6 became 'laying'.

Once the test group data (test_all) and the train group data (train_all) were joined, both datasets were merged into one (all_data), and sorted by subject (all_data_sorted)

***
(2) Extracting mean and standard deviation measurements from dataset

To extract the mean and standard deviation variables from the dataset, the features text file was read into R as a character vector file. The indices of the variable labels that contained the strings "mean", and "std" were extracted, combined, and sorted into the index vector meanStd.

The character "V" was pasted to each index integer to match the column names in the dataset. The two additional columns in the dataset ('subject', and 'activity') were also added to the vector newcolumns.  This vector was used to extract 81 columns from the dataset ('subject', 'activity', and 79 mean and standard deviation measurements ) into a new data frame: HAR_data

***
(4) Adding descriptive variable names to dataset

The index vector was also used to extract the descriptive labels for the variables. These were edited for clarity by removing the characters '()', "-", and _ from the labels, and the extra "Body" in the last 9 variables. The first letter of 'mean' and 'std' in the labels were also capitalized. It was decided that these labels were descriptive enough and were added as the variable names in data frame HAR_data

The script run_analysis.R also includes the creation of data frame 'meanStd.variable.identifiers' that lists the correlation between the column index numbers, V column labels of the original dataset, original label of measurements (from the features file), and the final variable names. This table is included as a separate file: "variable.identifiers.csv".

***
(5) Calculating average values for each measurement of each activity by subject

To create a new tidy dataset with the average of each variable for each activity and each subject the HAR_Data dataset was split by activity using the filter() function. For each activity data frame, the data was grouped by subject and the mean for each measurement was calculated. A new variable was included: nObs, which is the number of observations per subject for that activity that was used to calculate the mean.

The 6 resulting data frames: walking_avg, walkingUp_avg, walkingDown_avg, sitting_avg, standing_avg, and laying_avg, were then merged into one: HARdataAverages. The dataset is sorted by activity first, and subject second.

HARdataAverages was written as a text file: "HARdataAvg.txt" which is the dataset submitted for this assignment
