########################################
########IT Survey Monthly###############
########################################

###Clear Env. in R ----
  rm(list=ls())

### Load libraries ----
  library(Rsurveygizmo)
  library(dplyr)
  library(reshape2)
  library(ggplot2)
  library(tm)
  library(lubridate)

## Number of the Week and Sent Date
  week <- 1
  date <- "050218"
  
### Load IT Case from IT ---
  it_cases <- read.csv(paste0(asoto_repo, "Data/it_survey/weekly_lists/2018/Week",week,"_",date,".csv"),
                       na.strings=c("","NA"))

### Depublicate the cases
  it_cases <- it_cases[!duplicated(it_cases$caller_id.email), ]
  
### Create Date Sent Column
  it_cases$date_sent <- Sys.Date()
  
### Do not send survey to the same user for at least 60 days
  ###Creation for 90 days Exclusion List ----
  
  folder_sent_email <- "~/projects/asoto_repo/Data/it_survey/weekly_lists/2018/Sent/" 
  
  clists_email <- list.files(path = paste0(folder_sent_email), full.names = TRUE)
  clist_all_email <- do.call("rbind", lapply(clists_email, read.csv, header = TRUE))
  Email_Columns <- c("caller_id.email",
                      "caller_id",
                     "date_sent")
  clist_all_email <- clist_all_email[, Email_Columns ]
  clist_all_email$date_character <- as.character(clist_all_email$date_sent)
  clist_all_email$date_lubridate <- as.Date(clist_all_email$date_character, format="%m/%d/%y")
  clist_all_email$date_count <- as.numeric(Sys.Date() - clist_all_email$date_lubridate)
  
  
  #6 Days Exclusion ----
  clist_excl <- clist_all_email[(as.numeric(Sys.Date() - clist_all_email$date_lubridate))<61, ]
  
  ###Remove Not Longer Needed DF from Exclusion List Process ----
  rm(clist_all_email)
  
  ###  Exclusion List ----
  
  list_exclusion <- clist_excl$caller_id.email
  
  ### Not in the Exclusion List
    survey_list <- it_cases[!(it_cases$caller_id.email %in% list_exclusion), ]
    
    write.csv(survey_list, file = paste0(asoto_repo, "Data/it_survey/weekly_lists/2018/Week",week,"_",date,".csv"))
  
