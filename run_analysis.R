## Download and unzip the file from the url below
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
require(dplyr)

## Load all the relevent datasets into variables
features<-tbl_df(read.table(file="UCI HAR Dataset//features.txt"))
activity.labels<-tbl_df(read.table(file="UCI HAR Dataset//activity_labels.txt"))

subj.train<-tbl_df(read.table(file="UCI HAR Dataset//train//subject_train.txt"))
X.train<-tbl_df(read.table(file="UCI HAR Dataset/train/X_train.txt"))
y.train<-tbl_df(read.table(file="UCI HAR Dataset//train/y_train.txt"))

subj.test<-tbl_df(read.table(file="UCI HAR Dataset//test//subject_test.txt"))
X.test<-tbl_df(read.table(file="UCI HAR Dataset/test/X_test.txt"))
y.test<-tbl_df(read.table(file="UCI HAR Dataset//test/y_test.txt"))


X.full<-rbind(X.train,X.test) #1: Merging training and test
names(X.full)<-features$V2 #4: Rename variables with descriptive names

#2: Extracts only measurments of mean
colSelect<-grepl(pattern = "*mean()*",features$V2)|grepl(pattern = "*std()*",features$V2) 
X.full<-X.full[,colSelect]


y.full<-y.train %>% 
  rbind(y.test) %>% #1: Merging training and test
  left_join(activity.labels, by="V1") %>% #3 Descriptive activity names
  select(activity=V2)


subj.full<-rbind(subj.train,subj.test) #1: Merginge training and test
names(subj.full)<-"subject" #4 Rename variables with decriptive names

full.db<-tbl_df(cbind(subj.full,y.full,X.full)) #merge everything into one set (end of 4)

#Create tidy set with  average of each variable for each activity and each subject.
summary.db<-full.db %>%
  group_by(subject,activity) %>%
  summarise_each(funs(mean))

write.table(summary.db,row.names = F,file = "summary.txt")
