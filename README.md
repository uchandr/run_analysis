# run_analysis
Getting and Cleaning data assignment

The code run_analysis does the following:
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Code description
Note: The packages used are "dplyr" and "data.table"
The following files were extracted from UCI HAR Dataset folder which was downloaded to local directory.
X_train,Y_train,X_test,Y_test,subject_test,subject_train, features, activity_labels were the files extracted

The X_train and X_test files were merged and written to the file "combined"
The "features" file has the column names corresponsding to the "combined" dataset.
The column names for the "combined" file was added from the features file

Next the grep function was used to check for the column names that has either "mean"or "std" present
The column index was retrieved for those columns

finally only those measurements with mean and std were extracted from the "combined" file and written to meanstddata file
The activity id corresponding to each observation is present in Y_test and Y_train for X_test and X_train respectively.
The activity id file was merged for both test and train dataset and then in turn merged with activity_label file to map the activity 
name corresponding to the activity id.this dataframe was later merged with meanstddata to get the complete data frame - datafinal.

Next to calculate the mean of all measurements by activity and subject, convert the data frame to a data table
Get the mean of all the columns in the data table except for the group by columns - "activityid","activitylabel","subjectid"

Write this information into another data table aggregate.data

Finally write the aggregate.data to a .txt file aggregated_data.txt
