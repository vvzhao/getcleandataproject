## read test files
subject_test<-read.table("./test/subject_test.txt")
x_test<-read.table("./test/x_test.txt")
y_test<-read.table("./test/y_test.txt")
##merge test files
test<-cbind(subject_test,y_test,x_test)
##read training files
subject_train<-read.table("./train/subject_train.txt")
x_train<-read.table("./train/x_train.txt")
y_train<-read.table("./train/y_train.txt")
##merge training files
train<-cbind(subject_train,y_train,x_train)
##merge training and test data
data<-rbind(train, test)
##read features
feature<-read.table("features.txt")
activitylabel<-read.table("activity_labels.txt")
##find columns containing "mean" and "std
mean<-feature[grep("mean", feature[,2]),]
std<-feature[grep("std", feature[,2]),]
mean_std<-rbind(mean,std)
library(plyr)
mean_std<-arrange(mean_std, mean_std[,1])
##add 2 to column numbers since "subject" and "activity" were added to dataset 
column<-mean_std[,1]+2
##extract mean and std data
new_data <-data[,c(1,2,column)]
##find names of variables and change to character
variable<-mean_std[,2]
variable<-as.character(variable)
new_variable<-gsub("[[:punct:]]", " ", variable)
##assign variable names
names(new_data)<-c("Subject","Activity",new_variable)

## recode activities using decriptive names
new_data$Activity[new_data$Activity==1] <-"WALKING"
new_data$Activity[new_data$Activity==2] <-"WALKING_UPSTAIRS"
new_data$Activity[new_data$Activity==3] <-"WALKING_DOWNSTAIRS"
new_data$Activity[new_data$Activity==4] <-"SITTING"
new_data$Activity[new_data$Activity==5] <-"STANDING"
new_data$Activity[new_data$Activity==6] <-"LAYING"

##reshape data
library(reshape2)
dataMelt <-melt(new_data, id=c("Subject","Activity"))
## get average of each variable
average<- ddply(dataMelt, .(Subject, Activity,variable), summarize, mean=mean(value))
write.table(average, "average.txt",row.names=FALSE)