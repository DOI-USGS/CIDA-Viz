#library(jsonlite)
week_time <- seq.POSIXt(as.POSIXlt('2010-01-05'), as.POSIXlt('2014-09-20'), by = 'week')
#week_time <- seq.POSIXt(as.POSIXlt('2014-09-05'), as.POSIXlt('2014-09-20'), by = 'week')

sites = read.csv('../Data/ca_reservoirs.csv', as.is=TRUE)

# open all files, downsample and stick into list

num_steps <- length(week_time)
time_out <- vector('list',length=num_steps)
num_station <- nrow(sites)
for (j in 1:num_steps){
  stations <- vector('list', length=num_station)
  
  for (i in 1:num_station){
    stations[[i]] <- list(name=sites$ID[i], storage = NA)
    # downsample obs data
    period <- c(trunc(week_time[j]-3*86400, 'days'), trunc(week_time[j]+4*86400, 'days'))
    file_nm <- paste0('../storage_data/', sites$ID[i], '.csv')
    if (file.exists(file_nm)){
      dat <- read.csv(file = file_nm)
      dates <- as.POSIXlt(dat[,1])
      use_i <- dates <= period[2] & dates > period[1]
      if (sum(use_i) > 0){
        val <- mean(dat[use_i, 2], na.rm = TRUE)
        stations[[i]]$storage <- ifelse(is.na(val),NA,val)
      }
      
    }
    
    
  }
  cat('time:');cat(format(trunc(week_time[j], 'days')));cat('\n')
  time_out[[j]] <- list('time'=format(trunc(week_time[j], 'days')), 'station'=stations)
  
}
library(rjson)
json <- toJSON(time_out)
cat(json,file = '../storage_data/storage.json')

