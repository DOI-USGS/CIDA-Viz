#Get NWIS site info and daily discharge data in units of cubic meters per second CMS. NA indicates there is less that 80%

# setwd("~/Documents/R/CIDA-Viz/ca_discharge/R")
# library (dataRetrieval)

CaRefBasins<- read.csv("CaRefBasins.csv", header = TRUE, stringsAsFactors=FALSE, colClasses="character")
bad<- c("11154700")
iBad<- match(CaRefBasins$STAID, bad)
iBad<-is.na(iBad)
CaRefBasins<-CaRefBasins[iBad,]

sites<-CaRefBasins$STAID

siteINFO<-getNWISSiteInfo(sites)
siteINFOshort<-siteINFO[,2:3]                         #Shorten the dataset to the variables needed
siteINFOshort[,3:4]<-siteINFO[,7:8]

maxMissing <- 0.8                                     #fraction of site data that must be present since 1980 to use data

parameterCd <- "00060"                                #Discharge in CFS
startDate <-"1900-01-01"
endDate<- as.character(Sys.Date())                    #today
DOY <- as.numeric(strftime(endDate, format = "%j"))
DOY <- DOY-1                                          #techincally yesterday, for as today is still happening and we dont have all the data yet 





i=1

disStats <- as.data.frame(setNames(replicate(6,numeric(0), simplify = F), c("STAID", "siteName", "lat", "lon", "todayDis", "meanDis")))


for (i in 1:length(siteINFO$site.no)) {
      siteNumber <-siteINFO[i,2]
      
      Daily <- getNWISDaily(siteNumber,parameterCd, startDate, endDate, convert=TRUE) #get NWIS daily data and convert from CFS to CMS
      Daily[,13] <-substr(Daily$Date, 1, 4)
      colnames(Daily[13])<-"Year"
      
      #Build a table with STAID, Lat, Lon, meanDis, todayDis, site name
      iSite <- siteINFOshort==siteNumber
      info <- siteINFOshort[iSite,]
      disStats[i,1:4] <-info
      
      #Test for data after January 1, 1980
      iDates <-Daily$Julian >=47481
      if (any(iDates)) {
            
      #Subset for dates after January 1, 1980
            iSubset<- Daily$Julian>= 47481
            Daily <-Daily[iSubset,]
            
      iDOY <- Daily$Day==DOY
      dailyDis <-Daily[iDOY,]
      count <-length(dailyDis$Date)
      frac <- count/34
      

      
      enough <- frac>=maxMissing
      dataToday <- any(dailyDis$V13==2014)
      if (!enough | !dataToday ){
            disStats$todayDis[i] <- NA
            disStats$meanDis[i] <- NA
            
      } else {
            meanDis <- mean(dailyDis$Q)
            itodayDis <- dailyDis$V13==substr(endDate, 1, 4)
            todayDis <-dailyDis[itodayDis,]
            todayDis <-todayDis$Q
            disStats$todayDis[i] <-todayDis
            disStats$meanDis[i]  <-meanDis 
      }
     
      }else{ disStats$todayDis[i] <- NaN
             disStats$meanDis[i] <- NaN}
}
      
