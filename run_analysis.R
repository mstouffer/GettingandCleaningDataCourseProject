# Aquire data
library(dplyr)
path <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}
# Read data
trainingsub <- read.table(file.path(path, "train", "subject_train.txt"))
trainingval <- read.table(file.path(path, "train", "X_train.txt"))
trainingact <- read.table(file.path(path, "train", "y_train.txt"))
testsub <- read.table(file.path(path, "test", "subject_test.txt"))
testval <- read.table(file.path(path, "test", "X_test.txt"))
testact <- read.table(file.path(path, "test", "y_test.txt"))
feat <- read.table(file.path(path, "features.txt"), as.is = TRUE)
act <- read.table(file.path(path, "activity_labels.txt"))
colnames(act) <- c("activityId", "activityLabel")
# Merge the data
humanact <- rbind(
  cbind(trainingsub, trainingval, trainingact),
  cbind(testsub, testval, testact)
)
colnames(humanact) <- c("subject", feat[, 2], "activity")
# Extract the data
keepcolumns <- grepl("subject|activity|mean|std", colnames(humanact))
humanact <- humanact[, keepcolumns]
# Descriptive activity names
humanact$activity <- factor(humanact$activity, levels = act[, 1], labels = act[, 2])
# Label the data
humanactcols <- colnames(humanact)
humanactcols <- gsub("[\\(\\)-]", "", humanactcols)
humanactcols <- gsub("^f", "frequencyDomain", humanactcols)
humanactcols <- gsub("^t", "timeDomain", humanactcols)
humanactcols <- gsub("Acc", "Accelerometer", humanactcols)
humanactcols <- gsub("Gyro", "Gyroscope", humanactcols)
humanactcols <- gsub("Mag", "Magnitude", humanactcols)
humanactcols <- gsub("Freq", "Frequency", humanactcols)
humanactcols <- gsub("mean", "Mean", humanactcols)
humanactcols <- gsub("std", "StandardDeviation", humanactcols)
humanactcols <- gsub("BodyBody", "Body", humanactcols)
colnames(humanact) <- humanactcols
# Create the tidy data set
humanactmeans <- humanact %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(humanactmeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)