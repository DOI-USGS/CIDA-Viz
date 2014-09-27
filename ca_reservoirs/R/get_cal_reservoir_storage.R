library(RCurl)
library(XML)

scrape_ca_storage = function(site){
  theurl = sprintf('http://cdec.water.ca.gov/cgi-progs/queryDaily?%s&d=%s&span=5382days', 
                   site, '26-Sep-2014')
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
  return(data)
}

sites = read.csv('../Data/ca_reservoirs.csv', as.is=TRUE)

for(i in 1:nrow(sites)){
  
  tryCatch({
    data = scrape_ca_storage(sites$ID[i])
    
    write.table(data, paste0('../storage_data/', sites$ID[i], '.csv'), sep=',', row.names=FALSE)
    
    png(paste0('../storage_plots/', sites$ID[i], '.png'))
    plot(data[,1], data[,2], main=sites$ID[i], ylab='Storage(acre-feet)', xlab='')
    dev.off()
  }, error=function(err){})
}

#data = scrape_ca_storage('ORO')


