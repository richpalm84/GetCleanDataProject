#read in my files
subject_test <- read.table("subject_test.txt")
y_test <- read.table("y_test.txt")
x_test <- read.table("X_test.txt")
subject_train <- read.table("subject_train.txt")
y_train <- read.table("y_train.txt")
x_train <- read.table("X_train.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
#create test data frame by column binding.
test1 <- cbind(subject_test, y_test)
testcombined <- cbind(test1, x_test)
#create train data frame by column binding
train1 <- cbind(subject_train, y_train)
traincombined <- cbind(train1, x_train)
#create complete dataframe
df <- rbind(testcombined, traincombined)
#loading dplyr package
library(dplyr)
features1 <- filter(features, grepl('mean|std', V2))
names(df)[1] <- "subject"
names(df)[2] <- "activity"
df1 <- select(df, subject, activity, num_range("V", features1$V1))
df2 <- merge(df1, activity_labels, by.x = "activity", by.y = "V1")
df2 <- df2[,c(2,1,82,3:81)]
df2 <- df2[,-c(2)]
names(df2)[2] <- "activity"
x = c("V1","V2")
y = c("subject", "activity")
dft = data.frame(x,y)
colnames(dft) <- c("V1", "V2")
features2 <- rbind(dft, features1)
colnames(df2) <- features2$V2
df3 <- df2 %>% group_by(subject) %>% summarise_if(.predicate = function(x) is.numeric(x),
                                           .funs = funs(mean="mean"))
