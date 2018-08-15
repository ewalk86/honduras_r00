###compiling SUMs files for further analysis###
#Code from Sarah R, August 2018

library(dplyr)
library(tidyr)
library(acepack)
library(Hmisc)
library(stringr)
library(chron)

rm(list=ls())

setwd("C:/WorkDocs/cookstove_study/Data_R21/SUMs")

list.files<-list.files()
list.files<-gsub(".txt", "", list.files)
list.files<-list.files[-which(grepl("exposure_times.csv", list.files))]
list.files<-list.files[-which(grepl("processed", list.files))]

times <- read.delim("exposure_times.csv", header = TRUE, sep=",") #read file

#convert time format

times$setup_time_f <- gsub(" AM", "", times$setup_time) #delete AM
times$setup_time_f <- gsub(" PM", "", times$setup_time_f) #delete AM
times$setup_time_f <- gsub(":", "", times$setup_time_f) # replace : with nothing
times$setup_time_f <- str_pad(times$setup_time_f, width=4, side="left", pad=0)
times$setup_time_f <- paste(times$setup_time_f, "00", sep="")
times$setup_time_f <- sapply(times$setup_time_f, function(x) paste0(strsplit(x, "")[[1]][c(TRUE, FALSE)], strsplit(x, "")[[1]][c(FALSE, TRUE)], collapse=":"))
times$setup_time_f <- chron(times=times$setup_time_f)

for(i in list.files){
  
  file<-read.delim(i, header=F, sep=",", skip=20)
  colnames(file)<-c("timepoint","unit", "value")
  file<-as.data.frame(file) %>% separate(timepoint, c("date", "time"), " ", extra="merge")
  
  file$time_f<-gsub(" PM", "", file$time)
  file$time_f<-gsub(" AM", "", file$time_f)
  file$time_f<-sapply(file$time_f, function(x) paste(unlist(str_split(x, ":"))[c(1,2)], collapse=""))
  file$time_f<-ifelse(grepl("AM", file$time)==T, file$time_f, as.numeric(file$time_f)+1200)
  file$time_f<-str_pad(file$time_f, width=4, side="left", pad=0)
  file$time_f2<-substring(file$time_f,1,2)
  file$time_f3<-substring(file$time_f,3,4)
  file$time_f2<-gsub(12,00,file$time_f2)
  file$time_f2<-gsub(24,12,file$time_f2)
  file$time_f2<-str_pad(file$time_f2, width=2, side="left", pad=0)
  file$time_f<-paste(file$time_f2, file$time_f3, "00", sep=":")
  file$time_f<-chron(times=file$time_f)
  file$time_range<-sapply(file$time_f, function(x) paste(as.character(seq(chron(times=x), by=60/86400, length.out=5)), collapse=" "))
  
  ID<-unlist(strsplit(i,"_"))[1]
  setup_time<-times[which(grepl(ID, times$home_ID)),]$setup_time_f
  
  if(length(which(grepl(setup_time, file$time_range)))==0) next();
  
  start<-which(grepl(setup_time, file$time_range))[1]
  end<-start+288
  
  if(nrow(file)<end) next();
  
  file<-file[c(start:end),]
  file<-file[,c(1:4)]
  
  stove<-unlist(strsplit(i,"_"))[2]
  
  write.table(file, paste("./processed/",ID,"_",stove, "_processed.csv", sep=""), sep=",")
  
}