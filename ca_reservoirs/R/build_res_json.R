library(rjson)
week_time <- seq.POSIXt(as.POSIXlt('2000-01-04'), as.POSIXlt('2014-09-20'), by = 'week')


sites = read.csv('../Data/ca_reservoirs.csv', as.is=TRUE)

# open all files, downsample and stick into list
num_steps <- length(week_time)
time_out <- vector('list',length=num_steps)
num_station <- nrow(sites)
# load add data into a list
stations_all <- vector('list',length=num_station)
station_names <- vector(length=num_station)
rmv_i = vector(length = num_station)
for (i in 1:num_station){
  file_nm <- paste0('../storage_data/', sites$ID[i], '.csv')
  if (file.exists(file_nm)){
    dat <- read.csv(file = file_nm)
    dates <- as.POSIXlt(dat[,1])
    storage <- dat[, 2]
    stations_all[[i]] <- data.frame('dates'=dates, 'storage'=storage)
    station_names[i] <- sites$ID[i]
  } else {
    rmv_i[i] <- TRUE
  }
}
stations_all[rmv_i] <- NULL
station_names <- station_names[!rmv_i] 
num_station <- length(stations_all)
for (j in 1:num_steps){
  stations <- vector('list', length=num_station)
  
  for (i in 1:num_station){
    stations[[i]] <- list(name=station_names[i], storage = NULL)
    # downsample obs data
    period <- c(trunc(week_time[j]-3*86400, 'days'), trunc(week_time[j]+4*86400, 'days'))
    dates <- stations_all[[i]]$dates
    use_i <- dates <= period[2] & dates > period[1]
    if (sum(use_i) > 0){
      val <- mean(stations_all[[i]]$storage[use_i], na.rm = TRUE)
      if (!is.na(val)){
        stations[[i]]$storage <- val
      }
      
    }
    
    
  }
  cat('time:');cat(format(trunc(week_time[j], 'days')));cat('\n')
  time_out[[j]] <- list('time'=format(trunc(week_time[j], 'days')), 'station'=stations)
  
}

json <- toJSON(time_out)

cat(json,file = '../storage_data/storage.json')

