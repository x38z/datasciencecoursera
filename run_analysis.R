library(dplyr)
if(!file.exists("./UCI HAR Dataset")){
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")
unzip(zipfile="Data.zip",exdir=".")
}
#parsing observation files in test and train directories 
filelist_obs <- list.files(path = "C:/Users/x38z/Documents/UCI HAR Dataset", recursive = TRUE ,pattern= "^x_t(.*)txt" ,ignore.case=TRUE,full.names=TRUE )

 
datalist_obs <-  lapply(filelist_obs, function(x)read.table(x, header=F)) 

#assuming the same columns for all files
datafr_obs <- do.call("rbind", datalist_obs) 

#parsing activities files in test and train directories
filelist_activities <- list.files(path = "C:/Users/x38z/Documents/UCI HAR Dataset", recursive = TRUE ,pattern= "^y_t(.*)txt" ,ignore.case=TRUE,full.names=TRUE )

datalist_activities<-  lapply(filelist_activities, function(x)read.table(x, header=F))

datafr_act<- do.call("rbind", datalist_activities)

#parsing column names from features file and setting meaningful column names
features <- read.table("C:/Users/x38z/Documents/UCI HAR Dataset/features.txt")

clean_names=as.data.frame(clean_names)
clean_names<- tolower(gsub("\\(|\\)|\\,","",(gsub("-","_",features[[2]]))))
clean_names=as.data.frame(clean_names)
#Adding index for duplicate names
clean_names_ind<- paste(clean_names$clean_names,sep="_", seq.int(nrow(clean_names)))


colnames(datafr_obs)<- clean_names_ind
colnames(datafr_act)<- c("activity")

## selecting only mean and std columns

cleanfr<- cbind(select(datafr_obs,contains("mean"),contains("std")),datafr_act)
  #aggreated dataset by activity
final<-aggregate(x=cleanfr,by=list(cleanfr[,87]),FUN="mean")
