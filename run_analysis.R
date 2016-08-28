# ========================================================================================
# Task: Merges the training and the test sets to create one data set.

train <- cbind(
  read.table("UCI HAR Dataset/train/subject_train.txt"),
  read.table("UCI HAR Dataset/train/y_train.txt"), 
  read.table("UCI HAR Dataset/train/X_train.txt") 
)

test <- cbind(
  read.table("UCI HAR Dataset/test/subject_test.txt"),
  read.table("UCI HAR Dataset/test/y_test.txt"), 
  read.table("UCI HAR Dataset/test/X_test.txt") 
)

data <- rbind(train, test)

# ========================================================================================
# Task: Appropriately labels the data set with descriptive variable names. 

data_labels <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
data_labels <- data_labels[,2] # Extract only second columns
data_labels <- c("subject","activity",data_labels)  # Add name of merged column

colnames(data) <- data_labels

# ========================================================================================
# Task: Uses descriptive activity names to name the activities in the data set

activility <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
colnames(activility) <- c("id", "name")

data$activity <- factor(data$activity, levels = activility$id, labels = activility$name) 

# ========================================================================================
# Task:  Extracts only the measurements on the mean and standard deviation for each measurement. 

data <- data[ grep("subject|activity|mean\\(\\)|std\\(\\)", data_labels, value = TRUE) ]

write.table(data, file = "UCI HAR Dataset Tidy.csv",row.name=FALSE) 
# To read results use: read.table("UCI HAR Dataset Tidy.csv", header = TRUE)

# ========================================================================================
# Task: From the data set in step 4, creates a second, independent tidy data set 
#       with the average of each variable for each activity and each subject.

library(plyr)
data_mean <- ddply(data, .(subject, activity), numcolwise(mean))