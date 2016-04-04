setwd("C:/Users/jyoana/Desktop/ProjectData/UCI HAR Dataset/")

#Train sets labels and data 
trainSubject<- read.table("./train/subject_train.txt")
trainLabel<- read.table("./train/y_train.txt")
trainSet <- read.table("./train/x_train.txt")

#Naming the columns
names(trainSubject)<-"Subject"
names(trainLabel)<- "Activity"

#Test sets labels and data
testSubject <- read.table("./test/subject_test.txt")
testLabel <-read.table("./test/y_test.txt")
testSet<-read.table("./test/X_test.txt")

#Naming the columns
names(testSubject)<-"Subject"
names(testLabel)<- "Activity"

#Activity labels and converting the exsisting data into the given levels
Activity<- read.table("./activity_labels.txt",stringsAsFactors = FALSE)
Activity[, 2] <- tolower(gsub("_", "", Activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
trainLabel[,1]<-activity[trainLabel[, 1], 2]
testLabel[,1]<-activity[testLabel[, 1], 2]


# features contans the measurement labels
features<- read.table("./features.txt" ,stringsAsFactors = FALSE)

names(trainSet)<- features[,2]
names(testSet)<- features[,2]


#creating the completed train and test sets 

trainTotal<- cbind(trainSubject,trainLabel,trainSet)
testTotal<- cbind(testSubject,testLabel,testSet)

#combinig the train and test data 
totalData<-rbind(trainTotal,testTotal)

# removing tables that are not required anymore

rm(trainSet,testSet)
rm(trainLabel,testLabel)
rm(trainSubject,testSubject)

# filtering out the columns that are required 

tempIndices <- grep("Subject|Activity|mean\\(\\)|std\\(\\)", colnames(totalData))
FinalData<- totalData[,tempIndices]

# Renaming the columns accrding to requirement 

names(FinalData) <- gsub("\\(\\)", "", names(FinalData)) # remove "()"
names(FinalData) <- gsub("mean", "Mean", names(FinalData)) # capitalize M
names(FinalData) <- gsub("std", "Std", names(FinalData)) # capitalize S
names(FinalData) <- gsub("-", "", names(FinalData)) # remove "-" in column names 

write.table(FinalData, "FinalData.txt")

#cloning the data and generating means 
ans <- aggregate(FinalData[3:68],by=list(FinalData$Subject,FinalData$Activity),FUN = mean)

ans <- rename(ans,c("Group.1" ="Subject","Group.2"="Activity"))
ans <-arrange(ans,Subject)

#Writing the cleaned data file with the means 
write.table(ans,"FinalDataMean.txt",row.names = FALSE)



