library(plyr)

#Merges the training and the test sets to create one data set.
#Read train
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Read test
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merge train/test
data_x <- rbind(train_x, test_x)
data_y <- rbind(train_y, test_y)
data_subject <- rbind(train_subject, test_subject)
###############################################################################

#Extract only the measurements on the mean and standard deviation for each measurement
feat <- read.table("UCI HAR Dataset/features.txt")
#get cols with std mean names
mean_std <- grep("-(mean|std)\\(\\)", feat[,2])
data_x <- data_x[, mean_std]
#Correct cols names
names(data_x) <- feat[mean_std, 2]
###############################################################################

#Use descriptive activity names to name the activities in the data set

act <- read.table("UCI HAR Dataset/activity_labels.txt")

#update values with names
data_y[, 1] <- act[data_y[, 1], 2]

#correct col name
names(data_y) <- "activity"
##############################################################################

#Appropriately label the data set with descriptive variable names

#correct col name
names(data_subject) <- "subject"

#create single dataset
data <- cbind(data_x, data_y, data_subject)
###############################################################################

#Create a second, independent tidy data set with the average of each variable for 
#each activity and each subject.

data_avgs <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))

#create new data file
write.table(data_avgs, "data_avgs.txt", row.name=FALSE)
