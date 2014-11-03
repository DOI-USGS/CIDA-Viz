#Get NWIS site info and daily discharge data in units of cubic meters per second CMS. NA indicates there is less that 80%. 
#In table output, Na indicates not enough data after 1980, NaN indicates no data after 1980. 


#setwd("~/Documents/R/CIDA-Viz/ca_discharge/R")\

library (dataRetrieval)

CaRefBasins<- read.csv("CaRefBasins.csv", header = TRUE, stringsAsFactors=FALSE, colClasses="character")
bad<- c("11154700","11206800")                        #Some sites cause NWIS to give an error- these are two of them. 
iBad<- match(CaRefBasins$STAID, bad)
iBad<-is.na(iBad)
CaRefBasins<-CaRefBasins[iBad,]                       #Bad sites removed

sites<-CaRefBasins$STAID

siteINFO<-getNWISSiteInfo(sites)
siteINFOshort<-siteINFO[,2:3]                         #Shorten the INFO dataset to the variables needed
siteINFOshort[,3:4]<-siteINFO[,7:8]

maxMissing <- 0.8                                     #fraction of site data for DOY of interest that must be present since 1980 to use data

parameterCd <- "00060"                                #Discharge in CMS
startDate <-"1900-01-01"
endDate<- as.character(Sys.Date())                    #today

DOY <- as.numeric(strftime(endDate, format = "%j"))   #Make it today or make it any day you want. 
DOY <- DOY-1                                          #techincally yesterday, for as today is still happening and we dont have all the data yet 

#Setup the output data frame
disStats <- as.data.frame(setNames(replicate(6,numeric(0), simplify = F), c("STAID", "siteName", "lat", "lon", "todayDis", "meanDis")))

#Get data for each site, test for relevant data present, subset for relevant data, calc mean Q for previous dates
for (i in 1:length(siteINFO$site.no)) {
      siteNumber <-siteINFO$site.no[i]
      
      Daily <- getNWISDaily(siteNumber,parameterCd, startDate, endDate, convert=TRUE) #get NWIS daily data autmoatically converts to CMS
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
            
      #Subset for records of discharge on todays date (DOY) in years past and test if there's enough data
      iDOY <- Daily$Day==DOY
      dailyDis <-Daily[iDOY,]
      count <-length(dailyDis$Date)
      frac <- count/34  #!! what is 34?
      
      #enough data from the past?
      enough <- frac>=maxMissing
      
      #data for todays date?
      dataToday <- any(dailyDis$V13==2014)
      
      #if there's not enough data between 1980-today, table mean and current discharge values will read NA
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
     #If there is no data after 1980, mean and current discharge cell will read NaN
      }else{ disStats$todayDis[i] <- NaN
             disStats$meanDis[i] <- NaN}
}


write.csv(disStats, file="disStats.csv", row.names=FALSE)
dat <- read.csv(file='disStats.csv', header = T, sep=',')
