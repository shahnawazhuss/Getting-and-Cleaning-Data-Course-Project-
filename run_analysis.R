#Loading the data
dir <- paste(getwd(),"/UCI HAR Dataset/",sep="")
path1 <- "features.txt"
features <- read.table(file.path(dir,path1),colClasses = c("character"))
path1 <- "activity_labels.txt"
activity_labels <- read.table(file.path(dir,path1), col.names = c("ActivityId", "Activity"))
dir <- paste(getwd(),"/UCI HAR Dataset/train/",sep="")
path1 <- "X_train.txt"
x_train <- read.table(file.path(dir,path1))
path1 <- "y_train.txt"
y_train <- read.table(file.path(dir,path1))
path1 <- "subject_train.txt"
subject_train <- read.table(file.path(dir,path1))
dir <- paste(getwd(),"/UCI HAR Dataset/test/",sep="")
path1 <- "X_test.txt"
x_test <- read.table(file.path(dir,path1))
path1 <- "y_test.txt"
y_test <- read.table(file.path(dir,path1))
path1 <- "subject_test.txt"
subject_test <- read.table(file.path(dir,path1))

# Merging the training and the testing set
training_sensor_data <- cbind(cbind(x_train, subject_train), y_train)
test_sensor_data <- cbind(cbind(x_test, subject_test), y_test)
sensor_data <- rbind(training_sensor_data, test_sensor_data)\
#labeling the columns
sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_labels

#2. Extracting the measurements on the mean and standard deviation for each measurement.
require(plyr)
sensor_data_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

#3. Uses descriptive activity names to name the activities in the data set
sensor_data_mean_std <- join(sensor_data_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_data_mean_std <- sensor_data_mean_std[,-1]

# 4.labels the data set with descriptive names.

# Removing parentheses
names(sensor_data_mean_std) <- gsub('\\(|\\)',"",names(sensor_data_mean_std), perl = TRUE)
# Making syntactically valid names
names(sensor_data_mean_std) <- make.names(names(sensor_data_mean_std))
# Making clearer names

# 5. Creating a second, tidy data set with the average of each variable for each activity and each subject.

sensor_avg_by_act_sub = ddply(sensor_data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_avg_by_act_sub, file = "sensoravgbyactsub.txt",row.names = FALSE)
