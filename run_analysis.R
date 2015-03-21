testdata <- read.table("./test/X_test.txt")
testdataL <- read.table("./test/Y_test.txt")
testdataS <- read.table("./test/subject_test.txt")

traindata <- read.table("./train/X_train.txt")
traindataL <- read.table("./train/Y_train.txt")
traindataS <- read.table("./train/subject_train.txt")

alldataS<-rbind(testdataS, traindataS)
alldataL<-rbind(testdataL, traindataL)
alldata<-rbind(testdata, traindata)

alldata$lable<-alldataL
alldata$subject<-alldataS

test <- vector(mode="character", length=2947)
train <- vector(mode="character", length=7352)
test[1:2947]<-"test"
train[1:7352]<-"train"
testtrain<-c(test,train)
alldata$testtrain <-testtrain

features<- read.table("features.txt")
col<-c(as.character(features$V2), "label", "subject", "testtrain")
colnames(alldata)<-col


activity_labels <- read.table("activity_labels.txt")
alldata$label<-as.factor(alldata$label$V1)
levels(alldata$label) <- activity_labels$V2

x <-agrepl("mean", names(alldata))
y <-agrepl("std", names(alldata))
z<-x | y
alldatasub1<-alldata[,z]
alldatasub2<-alldata[, 562:563]
alldatasub<-cbind(alldatasub1, alldatasub2)

alldatasub3 <-alldatasub[, !(names(alldatasub) %in% "testtrain") ]
alldatasub3$subject<-as.factor(alldatasub3$subject$V1)
alldatasub3 <-split(alldatasub3, list(alldatasub3$label, alldatasub3$subject))
finaldata <-lapply(alldatasub3, function(x) colMeans(x[,1:86]))
write.table(finaldata, "finaldata.txt", sep=",")

