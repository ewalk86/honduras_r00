###SUMs peak values and % above x###
#Code from Sarah R, August 2018

rm(list=ls())

library(plyr)
library(dplyr)
library(tidyr)

setwd("C:/WorkDocs/cookstove_study/Data_R21/Longterm_SUMs/SUMs_data/long_files")

list.files<-list.files()
list.files<-list.files[-which(grepl("38values.csv", list.files))]
list.files<-list.files[-which(grepl("high_values.csv", list.files))]

### which files have values >38 ###

total<-data.frame(NULL)

for(i in list.files){
  file<-read.delim(i, header=T, sep=",")
  file$value_long<-ifelse(file$value_long>38,1,0)
  length<-nrow(file[which(grepl(1, file$value_long)),])
  length<-data.frame(v1=i, v2=length)
  total<-rbind(total, length)
}

count<-data.frame(v1="total", v2=sum(total$v2))
total<-rbind(total, count)                 

colnames(total)<-c("ID","no.of.values.greater.38")                  

write.csv(total, "38values.csv")

### which files have values >35, 38, 40, 45, 50 ###

total<-data.frame(NULL)

for(i in list.files){
  file<-read.delim(i, header=T, sep=",")
  file$value_long35<-ifelse(file$value_long>35,1,0)
  file$value_long38<-ifelse(file$value_long>38,1,0)
  file$value_long40<-ifelse(file$value_long>40,1,0)
  file$value_long45<-ifelse(file$value_long>45,1,0)
  file$value_long50<-ifelse(file$value_long>50,1,0)
  length35<-nrow(file[which(grepl(1, file$value_long35)),])
  length38<-nrow(file[which(grepl(1, file$value_long38)),])
  length40<-nrow(file[which(grepl(1, file$value_long40)),])
  length45<-nrow(file[which(grepl(1, file$value_long45)),])
  length50<-nrow(file[which(grepl(1, file$value_long50)),])
  length<-data.frame(v1=i, v2=length35, v3=length38, v4=length40, v5=length45, v6=length50)
  total<-rbind(total, length)
}

count<-data.frame(v1="total", v2=sum(total$v2), v3=sum(total$v3), v4=sum(total$v4), v5=sum(total$v5), v6=sum(total$v6))
total<-rbind(total, count)                 

colnames(total)<-c("ID","no.of.values.greater.35","no.of.values.greater.38","no.of.values.greater.40","no.of.values.greater.45","no.of.values.greater.50")                  

write.csv(total, "high_values.csv")
