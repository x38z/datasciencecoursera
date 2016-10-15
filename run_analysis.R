library(dplyr)
if(!file.exists("./UCI HAR Dataset")){
  fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="Dataset.zip")
unzip(zipfile="Data.zip",exdir=".")
}



obs_train<- read.table("./UCI HAR Dataset/train/X_train.txt")
obs_test<-read.table("./UCI HAR Dataset/test/x_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
activity_test<-read.table("./UCI HAR Dataset/test/y_test.txt")






features <- read.table("C:/Users/x38z/Documents/UCI HAR Dataset/features.txt")[,2]
extract_features <- grepl("mean|std", features)




colnames(obs_train)<- features
colnames(obs_test)<- features
colnames(activity_train)<- c("activity")
colnames(activity_test)<- c("activity")
colnames(subject_train)<- c("subject")
colnames(subject_test)<- c("subject")

activityNames <-
  c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")

## selecting only mean and std columns

cleanfr_train<- cbind(obs_train[extract_features],activity=activityNames[activity_train$activity],subject=subject_train$subject)
cleanfr_test<- cbind(obs_test[extract_features],activity=activityNames[activity_test$activity],subject=subject_test$subject)

# merging all

cleanfr<- rbind(cleanfr_train,cleanfr_test)



activities <- activityNames[cleanfr]


 ##final<-aggregate(x=cleanfr,by=list(cleanfr$activity,cleanfr$subject),FUN="mean")

library(plyr)

final<- ddply(cleanfr, .(subject, activity), function(x) colMeans(cleanfr[-c(80,81)] ))


 write.table(final, file = "./clean_data.txt")
