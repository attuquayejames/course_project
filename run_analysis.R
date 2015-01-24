##### 1.
##### Code that merges the training and the test sets to create one data set

train_x <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

##### combine data table (train and test data) by rows
x <- rbind (train_x, test_x)
y <- rbind(train_y, test_y)
z <- rbind(train_subject, test_subject)

##### 2.
##### code to extract measurements on the mean and standard deviation for each measurement

features <- read.table("./UCI HAR Dataset/features.txt")

##### assign riendly names to features column
names(features) <- c('features_id', 'features_name')

##### find matches to argument mean or 
##### standard deviation (sd)  within each element of character vector
features_extract <- grep("-mean\\(\\)|-std\\(\\)", features$features_name) 
x <- x[ , features_extract] 

##### Replaces all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[features_extract, 2]))


##### 3. employ descriptive activity names to name activities in the dataset
##### 4. Appropriate labels for data set using descriptive activity names
##### Read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
##### Friendly names to activities column
names(activities) <- c('activity_id', 'activity_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(z) <- "Subject"

##### Combines data table by columns
tidy_Data <- cbind(z, y, x)


##### 5. 
##### Code to create independent tidy data set with the average of each variable for each activity and each subject
temp <- tidy_Data[, 3 : dim (tidy_Data)[2]] 
tidy_mean_Data <- aggregate (temp, list(tidy_Data$Subject, tidy_Data$Activity), mean)

##### Activity and Subject name of columns 
names(tidy_mean_Data)[1] <- "Subject"
names(tidy_mean_Data)[2] <- "Activity"

##### Create a txt file with write.table() 
write.table(tidy_mean_Data, file = "./tidy_mean_data.txt", sep="\t", row.names=FALSE)
