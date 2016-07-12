#Get NWIS site info and daily discharge data in units of cubic meters per second CMS. NA indicates there is less that 80%. 
#In table output, Na indicates not enough data after 1980, NaN indicates no data after 1980. 


#setwd("~/Documents/R/CIDA-Viz/ca_discharge/R")\

library (dataRetrieval)

CaRefBasins<- read.csv("../Data/CaRefBasins.csv", header = TRUE, stringsAsFactors=FALSE, colClasses="character")

sites<-CaRefBasins$STAID

siteINFO<-readNWISsite(sites)
siteINFOshort<-siteINFO[,2:3]                         #Shorten the INFO dataset to the variables needed
siteINFOshort[,3:4]<-siteINFO[,7:8]

maxMissing <- 0.8                                     #fraction of site data for DOY of interest that must be present since 1980 to use data

parameterCd <- "00060"                                #Discharge in CMS
startDate <- as.Date("1980-01-01")
endDate   <- Sys.Date()                               #today


yesterday = endDate - as.difftime(1, units = 'days')
DOY <- as.POSIXlt(yesterday)$yday	+ 1                    #Make it today or make it any day you want. 

#Setup the output data frame
disStats <- as.data.frame(setNames(replicate(11,numeric(0), simplify = F), c("STAID", "siteName", "lat", "lon", "todayDis", "meanDis", "percent10", "percent25", "percent50", "percent75", "percent90")))

#Get data for each site, test for relevant data present, subset for relevant data, calc mean Q for previous dates
for (i in 1:length(siteINFO$site_no)) {
  siteNumber <-siteINFO$site_no[i]
  
  #Build a table with STAID, Lat, Lon, meanDis, todayDis, site name
  iSite <- siteINFOshort$site_no==siteNumber
  info <- siteINFOshort[iSite,]
  disStats[i,1:4] <-info
  
#   #check if data are available in the timeframe
#   dataInfo <- whatNWISdata(siteNumber, service='dv')
#   dataInfo = dataInfo[dataInfo$parm_cd == parameterCd,]
# 
#   if(nrow(dataInfo) < 1 || dataInfo$end_date < startDate){
#   	#then there is no data in our date/time range
#   	disStats$todayDis[i] <- NaN
#   	disStats$meanDis[i] <- NaN
#   	next
#   }
   
  tryCatch({
  	
  	Daily <- readNWISdv(siteNumber,parameterCd, startDate, endDate) #get NWIS daily data autmoatically converts to CMS
  	skip = FALSE
    if(ncol(Daily) == 0){skip = TRUE}
  }, error = function(e){
  		disStats$todayDis[i] <- NaN
  	 	disStats$meanDis[i] <- NaN
  		skip <<- TRUE
  })

	if(skip){
		next
	}
  
  dataColI = which(unlist(lapply(head(Daily), is.numeric)))
  # remove any bad values
	Daily = Daily[Daily[,dataColI] >= -999998 & !is.na(Daily[,dataColI]), ]

  
  Daily$Year <- as.POSIXlt(Daily$Date)$year + 1900
  Daily$doy <- as.POSIXlt(Daily$Date)$yday + 1 #convert jan 1st to one instead of zero
  
  #Test for data after January 1, 1980
  iDates <-Daily$Date >= startDate

  #If there is no data after 1980, mean and current discharge cell will read NaN
  if (!any(iDates)) {
  	disStats$todayDis[i] <- NaN
  	disStats$meanDis[i] <- NaN
  }else{
        
  	#Subset for dates after January 1, 1980
    iSubset<- Daily$Date >= startDate
    Daily <-Daily[iSubset,]
        
    #Subset for records of discharge on todays date (DOY) in years past and test if there's enough data
    iDOY <- Daily$doy==DOY
    dailyDis <-Daily[iDOY,]
    count <-nrow(dailyDis)
    frac <- count/34  # Hard coded number of years 
    
    #enough data from the past?
    enough <- frac>=maxMissing
    
    #data for todays date?
    dataToday <- any(dailyDis$Year==as.integer(format(Sys.Date(),"%Y"))) 
    
    #if there's not enough data between 1980-today, table mean and current discharge values will read NA
    if (!enough | !dataToday ){
          disStats$todayDis[i] <- NA
          disStats$meanDis[i] <- NA
          cat('Not enough data\n')
    } else {
    
          meanDis <- mean(dailyDis[,dataColI])
          itodayDis <- dailyDis$Year== (as.POSIXlt(endDate)$year+1900)
          todayDis <-dailyDis[itodayDis,]
          todayDis <-todayDis[,dataColI]
          disStats$todayDis[i]   <- todayDis
          disStats$meanDis[i]    <- meanDis 
          disStats$percent10[i]  <- quantile(dailyDis[,dataColI], 0.1)
          disStats$percent25[i]  <- quantile(dailyDis[,dataColI], 0.25)
          disStats$percent50[i]  <- quantile(dailyDis[,dataColI], 0.5)
          disStats$percent75[i]  <- quantile(dailyDis[,dataColI], 0.75)
          disStats$percent90[i]  <- quantile(dailyDis[,dataColI], 0.9)
          
    }
  }
	cat("on iteration ", i, '\n')
}


write.csv(disStats, file="../Data/disStats.csv", row.names=FALSE)


