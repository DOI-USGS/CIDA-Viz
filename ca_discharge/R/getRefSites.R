
#Opens GAGESII files to identify station IDS (STAID) for reference sites in california. Writes file with STAIDs, state, and ref class. 


library(dplyr)

#Assume working directory is set to this file location
#setwd("~/Documents/R/CIDA-Viz/ca_discharge/R")

BasinID <- read.csv("../Data/gagesII_sept30_2011_conterm_BasinID.csv", header = TRUE, stringsAsFactors=FALSE, colClasses="character")
Bas_Classif <- read.csv("../Data/gagesII_sept30_2011_conterm_Bas_Classif.csv", header = TRUE, stringsAsFactors=FALSE, colClasses="character")
      

STAID<-as.character(BasinID$STAID)
STATE<-as.character(BasinID$STATE)

AllBasinID<-BasinID$STAID
AllBasinID <-as.data.frame(cbind(AllBasinID,STATE))
iCa<-AllBasinID$STATE=="CA"
CaBasinID<-AllBasinID[iCa, ]


CLASS <-as.character(Bas_Classif$CLASS)
All_Bas_Classif <-Bas_Classif$STAID
All_Bas_Classif <-as.data.frame(cbind(All_Bas_Classif, CLASS))

iref<-All_Bas_Classif$CLASS=="Ref"
All_RefID<-as.data.frame(All_Bas_Classif[iref,])

colnames(All_RefID)<-c("STAID","CLASS")
colnames(CaBasinID)<-c("STAID","STATE")

CaRefBasins<-merge(All_RefID,CaBasinID)

write.csv(CaRefBasins, file="../Data/CaRefBasins.csv")

