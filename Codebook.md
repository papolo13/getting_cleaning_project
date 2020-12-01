# CodeBook

The run_analysis.R script transform the raw data that is in the 'data' folder into tidy data. The steps and variable created for this purpose were described:

1. Merge the data

The following variables were created:
 - test_files: List of files in the relative direction 'data/UCI HAR Dataset/test/'.
 - tarin_files: List of files in the relative direction 'data/UCI HAR Dataset/train/'.
 - test_list: List that contains all the extract files that are in test_files.
 - train_list: List that contains all the extract files that are in train_files.
 - df_test: Dataframe that results from the column bind of all the dataframes in test_list.
 - df_train: Dataframe that results from the column bind of all the dataframes in train_list.
 - df_union: Merge the dataframes of test and train with row bind.

2. Extract mean and std measures

There the function 'select' was applied to df_union to select all the columns that contains 'mean' or 'std' in their names.

3. Descriptive activity names

Put the name of the activity that refers the 'label' column.

4. Descriptive variable names

Use of regular expressions to clean and put a descriptive name to all the columns.

5. Summarise data

Use dplyr to summarise all the variables in the dataset by subject and activity.


