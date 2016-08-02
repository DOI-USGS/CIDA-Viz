library(RCurl)
library(XML)

scrape_ca_storage = function(site){
  #Deal with if csv does not exist
  filePath <- paste0('../storage_data/', site, '.csv')
  if(file.exists(filePath)){
    existingData <- read.csv(filePath, stringsAsFactors = FALSE)
    names(existingData) = c("Date", "Storage(acre-feet)")
    existingData$Date <- as.POSIXlt(existingData$Date)  
    lastDay <- tail(existingData$Date[!is.na(existingData$`Storage(acre-feet)`)],1)
    #get rid of any NA at and existing data
    existingData <- existingData[existingData$Date <= lastDay,] 
    #days in URL is before today, and today is counted by difftime
    numdays <- as.integer(difftime(Sys.Date(),as.Date(lastDay),units="days")) - 1 
    allNewData <- FALSE
  }else{
    numDays <- 5382 #as per the original URL construction  
    allNewData <- TRUE
  }
  #todo: input number of days to retrieve in url
  theurl = sprintf('http://cdec.water.ca.gov/cgi-progs/queryDaily?%s&d=%s&span=%sdays', 
                   site, format(Sys.time(), '%d-%b-%y'), numdays)
  cat(theurl,'\n')
  tables = readHTMLTable(theurl)
  
  ## it seems to be the only table grabbed. We must be lucky
  data = tables[[1]]
  data = data[,c('Date', 'STORAGE&nbsp')]
  
  #2nd row are units. Drop them
  data = data[-1,]
  names(data) = c("Date", "Storage(acre-feet)")
  
  data$Date = strptime(data$Date, '%m/%d/%Y')
  data$`Storage(acre-feet)` = as.numeric(as.character(data[,2]))
  
  if(!allNewData){
    data <- rbind(existingData,data)
  }
  
  
  return(data)
}

sites = read.csv('../Data/ca_reservoirs.csv', as.is=TRUE)

for(i in 1:nrow(sites)){
  
  tryCatch({
    data = scrape_ca_storage(sites$ID[i])
    
    write.table(data, paste0('../storage_data/', sites$ID[i], '.csv'), sep=',', row.names=FALSE)
    
    #png(paste0('../storage_plots/', sites$ID[i], '.png'))
    #plot(data[,1], data[,2], main=sites$ID[i], ylab='Storage(acre-feet)', xlab='')
    #dev.off()
  }, error=function(err){})
}

#data = scrape_ca_storage('ORO')


