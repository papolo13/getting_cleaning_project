##%######################################################%##
#                                                          #
####                     LIBRERIES                      ####
#                                                          #
##%######################################################%##

library(dplyr)
library(magrittr)

##%######################################################%##
#                                                          #
####                       MERGE                        ####
#                                                          #
##%######################################################%##

# Files to read
test_files <- list.files("data/UCI HAR Dataset/test/")
train_files <- list.files("data/UCI HAR Dataset/train/")

test_files <- grep(".*\\.txt", test_files, value = TRUE)
train_files <- grep(".*\\.txt", train_files, value = TRUE)

# Read files
test_list <- lapply(test_files, 
                    function(x) read.table(paste0("data/UCI HAR Dataset/test/",x)))
train_list <- lapply(train_files, 
                     function(x) read.table(paste0("data/UCI HAR Dataset/train/",x)))

# Column bind lists
df_test <- do.call(cbind, test_list)
df_train <- do.call(cbind, train_list)

# Format columnames
activity_names <- read.table("data/UCI HAR Dataset/activity_labels.txt",
                             col.names = c("label", "activity"))
features_names <- read.table("data/UCI HAR Dataset/features.txt",
                             col.names = c("label", "feature"))
names(df_test) <- c("subject", features_names$feature, "label")
names(df_train) <- c("subject", features_names$feature, "label")

# Row bind dataframes
df_test$ind <- "test"
df_train$ind <- "train"

df_union <- rbind(df_test, df_train)

##%######################################################%##
#                                                          #
####           EXTRACT MEAN AND STD MEASURES            ####
#                                                          #
##%######################################################%##

df_union %<>% select(subject, label, contains("mean"), contains("std")) 

##%######################################################%##
#                                                          #
####             DESCRIPTIVE ACTIVITY NAMES             ####
#                                                          #
##%######################################################%##

df_union$label <- activity_names[df_union$label, 2]

##%######################################################%##
#                                                          #
####                  APPROPIATE LABEL                  ####
#                                                          #
##%######################################################%##

df_union %<>% rename(activity = label)
df_names <- names(df_union)
df_names <- tolower(df_names)
df_names <- gsub("-|\\(\\)|\\(|\\)|,", "", df_names)
df_names <- gsub("^t", "time", df_names)
df_names <- gsub("^f", "frequency", df_names)
df_names <- gsub("acc", "accelerometer", df_names)
df_names <- gsub("gyro", "gyroscope", df_names)
df_names <- gsub("mag", "magnitude", df_names)
df_names <- gsub("bodybody", "body", df_names)
df_names <- gsub("tbody", "timebody", df_names)
names(df_union) <- df_names

##%######################################################%##
#                                                          #
####                   SUMMARISE DATA                   ####
#                                                          #
##%######################################################%##

df_summary <- df_union %>% 
    group_by(subject, activity) %>% 
    summarise(across(where(is.numeric), mean))

##---- Export ----
write.table(df_summary, "output/tidy_data.txt", row.names = FALSE)





