# Reading trainings tables
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

#Reading testing tables
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector
features<-read.table("UCI HAR Dataset/features.txt")

#Reading activity labels
activity_labels=read.table("UCI HAR Dataset/activity_labels.txt")

#Assigning column names
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityID"
colnames(subject_train)<-"subjectID"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityID"
colnames(subject_test)<-"subjectID"

colnames(activity_labels)<-c('activityID','activityType')

#Merging data to one dataset
mrg_train<-cbind(y_train,subject_train,x_train)
mrg_test<-cbind(y_test,subject_test,x_test)
OneData<-rbind(mrg_train,mrg_test)

#Read column names
colNames<-colnames(OneData)

#Create vector for definint ID, mean and st deviation
mean_and_std<-(grepl("activityID",colNames)|
              grepl("subjectID",colNames)|
              grepl("mean..",colNames)|
              grepl("std..",colNames)
              )

#Creating necessary subset
mean_and_std<-OneData[,mean_and_std==TRUE]

#Name activities
ActivityNames<-merge(mean_and_std,activity_labels,by='activityID',all.x=TRUE)

#Tidy Dataset
TidyData<-aggregate(.~subjectID+activityID,ActivityNames,mean)
TidyData<-TidyData[order(TidyData$subjectID,TidyData$activityID),]
write.table(TidyData,"TidyData.txt",row.name=FALSE)


                        