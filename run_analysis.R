## Create one R script called run_analysis.R that does the following:

library(data.table)
## 1. Merges the training and the test sets to create one data set.
testx <- read.table(".\\getdata\\test\\X_test.txt",sep = "")
testy <- read.table(".\\getdata\\test\\y_test.txt",sep = "")
trainx <- read.table(".\\getdata\\train\\X_train.txt",sep = "")
trainy <- read.table(".\\getdata\\train\\y_train.txt",sep = "")
subtrain <- read.table(".\\getdata\\train\\subject_train.txt",stringsAsFactors = FALSE)
subtest <- read.table(".\\getdata\\test\\subject_test.txt",stringsAsFactors = FALSE)

names(subtrain) <- "subject"
names(subtest) <- "subject"
names(trainy) <- "y"
names(testy) <- "y"
# Mtest <- cbind(testx,testy)
# Mtrain <- cbind(trainx,trainy)
# MD <- rbind(Mtest,Mtrain)
Ms <- rbind(subtest,subtrain)
Mx <- rbind(testx,trainx)
My <- rbind(testy,trainy)
MD <- cbind(Ms,Mx,My)
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(".\\getdata\\features.txt",stringsAsFactors = FALSE)
ex_feature <- grep("mean|std",features[,2])
Mx2 <- Mx[,ex_feature]
MD2 <- cbind(Ms,Mx2,My)
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
activity <- read.table(".\\getdata\\activity_labels.txt", sep = "")
names(activity) <- c("num","activitylabels")
names(MD2)[2:80] <- features[ex_feature,2]
copy_MD2 <- MD2
mergeD <- merge(copy_MD2,activity,by.x = "y",by.y = "num",all = T)  ## reorder 
mergeD1 <- mergeD[,2:82]

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
names(mergeD1)
meltD <- melt(mergeD1, id.vars = c("subject","activitylabels"))
castD <- dcast(meltD,subject + activitylabels ~ variable, mean)

write.table(castD, file="tidyD.txt",row.name=FALSE)

tyD <-read.table("tidyD.txt")
