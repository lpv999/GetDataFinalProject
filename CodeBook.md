Johns Hopkins / Coursera Data Science Specialization
Course: Getting and Cleaning Data
Final Project Code Book

Dataset:
==================================================================
UCI HAR Dataset downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
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

The script run_analysis.R also includes the creation of data frame 'meanStd.variable.identifiers' that lists the correlation between the column index numbers, V column labels of the original dataset, original label of measurements (from the features file), and the final variable names. This table is included at the end of this document and as a separate file: "variable.identifiers.txt".

***
(5) Calculating average values for each measurement of each activity by subject

To create a new tidy dataset with the average of each variable for each activity and each subject the HAR_Data dataset was split by activity using the filter() function. For each activity data frame, the data was grouped by subject and the mean for each measurement was calculated. A new variable was included: nObs, which is the number of observations per subject for that activity that was used to calculate the mean.

The 6 resulting data frames: walking_avg, walkingUp_avg, walkingDown_avg, sitting_avg, standing_avg, and laying_avg, were then merged into one: HARdataAverages. The dataset is sorted by activity first, and subject second.

HARdataAverages was written as a text file: "HARdataAvg.txt" which is the dataset submitted for this assignment

***
Variable identifiers
=====================================================
"colIndex" "Vnumber" "featureName" "newVariableName"
1 "V1""tBodyAcc-mean()-X" "tBodyAccMeanX"
2 "V2" "tBodyAcc-mean()-Y" "tBodyAccMeanY"
3 "V3" "tBodyAcc-mean()-Z" "tBodyAccMeanZ"
4 "V4" "tBodyAcc-std()-X" "tBodyAccStdX"
5 "V5" "tBodyAcc-std()-Y" "tBodyAccStdY"
6 "V6" "tBodyAcc-std()-Z" "tBodyAccStdZ"
41 "V41" "tGravityAcc-mean()-X" "tGravityAccMeanX"
42 "V42" "tGravityAcc-mean()-Y" "tGravityAccMeanY"
43 "V43" "tGravityAcc-mean()-Z" "tGravityAccMeanZ"
44 "V44" "tGravityAcc-std()-X" "tGravityAccStdX"
45 "V45" "tGravityAcc-std()-Y" "tGravityAccStdY"
46 "V46" "tGravityAcc-std()-Z" "tGravityAccStdZ"
81 "V81" "tBodyAccJerk-mean()-X" "tBodyAccJerkMeanX"
82 "V82" "tBodyAccJerk-mean()-Y" "tBodyAccJerkMeanY"
83 "V83" "tBodyAccJerk-mean()-Z" "tBodyAccJerkMeanZ"
84 "V84" "tBodyAccJerk-std()-X" "tBodyAccJerkStdX"
85 "V85" "tBodyAccJerk-std()-Y" "tBodyAccJerkStdY"
86 "V86" "tBodyAccJerk-std()-Z" "tBodyAccJerkStdZ"
121 "V121" "tBodyGyro-mean()-X" "tBodyGyroMeanX"
122 "V122" "tBodyGyro-mean()-Y" "tBodyGyroMeanY"
123 "V123" "tBodyGyro-mean()-Z" "tBodyGyroMeanZ"
124 "V124" "tBodyGyro-std()-X" "tBodyGyroStdX"
125 "V125" "tBodyGyro-std()-Y" "tBodyGyroStdY"
126 "V126" "tBodyGyro-std()-Z" "tBodyGyroStdZ"
161 "V161" "tBodyGyroJerk-mean()-X" "tBodyGyroJerkMeanX"
162 "V162" "tBodyGyroJerk-mean()-Y" "tBodyGyroJerkMeanY"
163 "V163" "tBodyGyroJerk-mean()-Z" "tBodyGyroJerkMeanZ"
164 "V164" "tBodyGyroJerk-std()-X" "tBodyGyroJerkStdX"
165 "V165" "tBodyGyroJerk-std()-Y" "tBodyGyroJerkStdY"
166 "V166" "tBodyGyroJerk-std()-Z" "tBodyGyroJerkStdZ"
201 "V201" "tBodyAccMag-mean()" "tBodyAccMagMean"
202 "V202" "tBodyAccMag-std()" "tBodyAccMagStd"
214 "V214" "tGravityAccMag-mean()" "tGravityAccMagMean"
215 "V215" "tGravityAccMag-std()" "tGravityAccMagStd"
227 "V227" "tBodyAccJerkMag-mean()" "tBodyAccJerkMagMean"
228 "V228" "tBodyAccJerkMag-std()" "tBodyAccJerkMagStd"
240 "V240" "tBodyGyroMag-mean()" "tBodyGyroMagMean"
241 "V241" "tBodyGyroMag-std()" "tBodyGyroMagStd"
253 "V253" "tBodyGyroJerkMag-mean()" "tBodyGyroJerkMagMean"
254 "V254" "tBodyGyroJerkMag-std()" "tBodyGyroJerkMagStd"
266 "V266" "fBodyAcc-mean()-X" "fBodyAccMeanX"
267 "V267" "fBodyAcc-mean()-Y" "fBodyAccMeanY"
268 "V268" "fBodyAcc-mean()-Z" "fBodyAccMeanZ"
269 "V269" "fBodyAcc-std()-X" "fBodyAccStdX"
270 "V270" "fBodyAcc-std()-Y" "fBodyAccStdY"
271 "V271" "fBodyAcc-std()-Z" "fBodyAccStdZ"
294 "V294" "fBodyAcc-meanFreq()-X" "fBodyAccMeanFreqX"
295 "V295" "fBodyAcc-meanFreq()-Y" "fBodyAccMeanFreqY"
296 "V296" "fBodyAcc-meanFreq()-Z" "fBodyAccMeanFreqZ"
345 "V345" "fBodyAccJerk-mean()-X" "fBodyAccJerkMeanX"
346 "V346" "fBodyAccJerk-mean()-Y" "fBodyAccJerkMeanY"
347 "V347" "fBodyAccJerk-mean()-Z" "fBodyAccJerkMeanZ"
348 "V348" "fBodyAccJerk-std()-X" "fBodyAccJerkStdX"
349 "V349" "fBodyAccJerk-std()-Y" "fBodyAccJerkStdY"
350 "V350" "fBodyAccJerk-std()-Z" "fBodyAccJerkStdZ"
373 "V373" "fBodyAccJerk-meanFreq()-X" "fBodyAccJerkMeanFreqX"
374 "V374" "fBodyAccJerk-meanFreq()-Y" "fBodyAccJerkMeanFreqY"
375 "V375" "fBodyAccJerk-meanFreq()-Z" "fBodyAccJerkMeanFreqZ"
424 "V424" "fBodyGyro-mean()-X" "fBodyGyroMeanX"
425 "V425" "fBodyGyro-mean()-Y" "fBodyGyroMeanY"
426 "V426" "fBodyGyro-mean()-Z" "fBodyGyroMeanZ"
427 "V427" "fBodyGyro-std()-X" "fBodyGyroStdX"
428 "V428" "fBodyGyro-std()-Y" "fBodyGyroStdY"
429 "V429" "fBodyGyro-std()-Z" "fBodyGyroStdZ"
452 "V452" "fBodyGyro-meanFreq()-X" "fBodyGyroMeanFreqX"
453 "V453" "fBodyGyro-meanFreq()-Y" "fBodyGyroMeanFreqY"
454 "V454" "fBodyGyro-meanFreq()-Z" "fBodyGyroMeanFreqZ"
503 "V503" "fBodyAccMag-mean()" "fBodyAccMagMean"
504 "V504" "fBodyAccMag-std()" "fBodyAccMagStd"
513 "V513" "fBodyAccMag-meanFreq()" "fBodyAccMagMeanFreq"
516 "V516" "fBodyBodyAccJerkMag-mean()" "fBodyAccJerkMagMean"
517 "V517" "fBodyBodyAccJerkMag-std()" "fBodyAccJerkMagStd"
526 "V526" "fBodyBodyAccJerkMag-meanFreq()" "fBodyAccJerkMagMeanFreq"
529 "V529" "fBodyBodyGyroMag-mean()" "fBodyGyroMagMean"
530 "V530" "fBodyBodyGyroMag-std()" "fBodyGyroMagStd"
539 "V539" "fBodyBodyGyroMag-meanFreq()" "fBodyGyroMagMeanFreq"
542 "V542" "fBodyBodyGyroJerkMag-mean()" "fBodyGyroJerkMagMean"
543 "V543" "fBodyBodyGyroJerkMag-std()" "fBodyGyroJerkMagStd"
552 "V552" "fBodyBodyGyroJerkMag-meanFreq()" "fBodyGyroJerkMagMeanFreq"
