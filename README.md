# tidy_data - Coursera getting and cleaning data assignment.

## Observations:
I don't have enough experience to judge if datasets are normally presented in the way this one was presented, however my background in computer science lead to this being very difficult to understand the ordering of the dataset.  It doesn't make sense or seem efficient to me to separate the various aspects of the data in the way that it was separated.  In addition once separated the data was (with the exception of the activity label) only correlated by ordering in the datasets.  This strikes me as unreliable and unintuitive.  If I were to be saving this data to a database I would either combine it OR I would include links rather than rely on implicit ordering.  IE the order of the training observations correlates with the ordering of the subjects in the companion data set.  I don't believe this arrangement is conducive to understanding the information, and furthermore unless this mechanism correlates strongly to a known and observed convention in the industry I wouldn't recomend using the same scheme.

## Process
Data originates from: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
Actual data set downloaded from project page on coursera: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Unzip data into working directory with default name from zip file "UCI HAR Dataset"

Run script:
* The script will check to ensure a required library "reshape2" is installed.
* The script will check to ensure the required subdirectory with data is present.
* Load all heading data (activity labels, feature list).
* Load all test / training data 
  * This includes ancillary data such as implicitly ordered features + subjects and activity labels.
* Assigns column names to primary training / testing data using heading data already collected.
* Assigns column names via hardcoding for companion datasets (Activity, subject datasets).
* Binds activity_id and subject_id to testing / training dataset via cbind which associates the records using the order of the files as implicit linkages.
* Bind the testing / training datasets together via rbind.
* There are 561 variables involved, I grepped through feature list to find all observations that included 'mean' and 'std' in the feature name.  
* All feature names with 'mean' and 'std' extracted into a new dataset.
* Melted mean and std data: Grouped by activity_id, activity_name and subject_id.  The goal was to come up with a list of rows that only contain single observations.
* Reshaped Data to contain the mean of all mean/std variables group by subject and activity.

## Acknowledgements:
* Coursera forum threads:
  * https://class.coursera.org/getdata-015/forum/thread?thread_id=26
  * https://class.coursera.org/getdata-015/forum/thread?thread_id=27
  * https://class.coursera.org/getdata-015/forum/thread?thread_id=113
