
# require reshape 2 library 
if (!("reshape2" %in% rownames(installed.packages()))) {
  stop("this script requires reshape2 to be installed.")
}

if (!("UCI HAR Dataset" %in% dir())){
  stop("Data missing or not extracted into different directory.  See README.md")
}

library(reshape2)

# extract activity labels, for later use.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity_name"))

# extract the column names for the data files.
feature_labels <- read.table("./UCI HAR Dataset/features.txt", col.names = c("feature_id", "feature_name"))

# extract the various data and it's implicitly ordered components.
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# assign column names to the various component data sets
colnames(train_data) <- feature_labels[,2]
colnames(test_data) <- feature_labels[,2]
colnames(test_labels) <- "activity_id"
colnames(test_subject) <- "subject_id"
colnames(train_labels) <- "activity_id"
colnames(train_subject) <- "subject_id"

# Attach id's for labels(Activities) and subjects to test data.  
# Rely on implicit ordering to make sense of it
complete_test_data <- cbind(test_labels, test_subject, test_data)
complete_train_data <- cbind(train_labels, train_subject, train_data)
complete_all_data <- rbind(complete_test_data, complete_train_data)

# I think we can grep through the columns to get the 'std' and 'mean' columns
mean_columns_index <- grep("mean", names(complete_all_data), ignore.case = TRUE)
mean_columns_names <- names(complete_all_data[mean_columns_index])
std_columns_index <- grep("std", names(complete_all_data), ignore.case = TRUE)
std_columns_names <- names(complete_all_data[std_columns_index])

# extract the subject/activity id columsn + the mean and std columns identified above.
mean_and_std_data <- complete_all_data[, c("subject_id", "activity_id",mean_columns_names, std_columns_names)]

# merge in descriptive activity name, this is the only piece of the puzzle that has a sane reference :)
mean_and_std_data_descriptive_names <- merge(mean_and_std_data, activity_labels, by.x="activity_id", by.y="activity_id", all = TRUE )

# melt data, produces long skinny data set with one observation / row (as opposed 565ish observations / row)
melted_data <- melt(mean_and_std_data_descriptive_names, id=c("activity_id", "activity_name", "subject_id"))

# summarize (group by) all by activity, subject and variable to mean of variable
tidy_data_mean_of_melted <- ddply(melted_data, c("activity_id", "activity_name", "subject_id", "variable"), summarize, mean_of_variable = mean(value))

# write the tidy data to local file
write.table(tidy_data_mean_of_melted, file="tidy_data.txt",row.name=FALSE)
