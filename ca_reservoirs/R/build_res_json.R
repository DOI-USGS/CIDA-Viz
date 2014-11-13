library(rjson)

first_date <- as.POSIXlt('2011-01-04')
week_time <- seq.POSIXt(first_date, as.POSIXlt(Sys.time()), by = 'week')
library(jsonlite)
json_res <- jsonlite::fromJSON('../Data/ca_reservoirs.json')
#yes, this is goofy
detach("package:jsonlite", unload=TRUE)


qaqc_flags <- function(data){
  library('sensorQC')
  mad_vals <- MAD(data)
  bad_i <- mad_vals > 3 | data < 0 | is.na(data)# conservative
  return(bad_i)
}
#This interpolates small gaps, in the middle of data
# and then returns the original 
interp.storage = function (dates, data, first_date){
  max.gap = 21*24 # days * hours
  bad.data <- qaqc_flags(data)
  date_use <- dates >= first_date
	snip.dates = dates[!bad.data & date_use]
	snip.data = data[!bad.data & date_use]
  gaps <- as.numeric(diff(snip.dates))
  if (any(gaps > max.gap) | sum(!is.na(snip.data)) < 3){
    return(data.frame(x=NA,y=NA))
  } else {
    fixed.data = approx(snip.dates, snip.data, dates[date_use])
    
    return(fixed.data)
  }
}


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
    dates <- as.POSIXct(dat[,1])
    storage <- dat[, 2]
    new.storage = interp.storage(dates, storage, first_date)
    
    stations_all[[i]] <- data.frame('dates'=new.storage$x, 'storage'=new.storage$y)
    station_names[i] <- sites$ID[i]
    if (length(new.storage$x) == 1){
      # single value returned as NA
      rmv_i[i] <- TRUE
    }
  } else {
    rmv_i[i] <- TRUE
  }
}
stations_all[rmv_i] <- NULL
station_names <- station_names[!rmv_i] 
num_station <- length(stations_all)

reservoirs <- vector('list', length = num_station )
rmv_station <- vector(length = num_station )
for (i in 1:num_station){
  print(i)
  res_mat <- matrix(nrow = num_steps, ncol = 1)
  for (j in 1:num_steps){
    period <- c(trunc(week_time[j]-3*86400, 'days'), trunc(week_time[j]+4*86400, 'days'))
    dates <- stations_all[[i]]$dates
    use_i <- dates <= period[2] & dates > period[1]
    if (sum(use_i) > 0){
      val <- mean(stations_all[[i]]$storage[use_i], na.rm = TRUE)
      if (!is.na(val)){
        res_mat[j,1] <- val
      }
      
    }
  }

  rmv_station[i] <- any(is.na(res_mat[,1])) # should be none!!
  j_id <- which(json_res$ID == station_names[i])
  cap <- json_res[j_id, 10]
  
  if (is.na(cap)){
    cap <- max(res_mat[,1])
  }
  reservoirs[[i]] <- list("Station"=json_res$Station[j_id],"ID"=station_names[i],
                          "Elev"=json_res$Elev[j_id], "Latitude"=json_res$Latitude[j_id], "Longitude" = json_res$Longitude[j_id],
                    "County"=json_res$County[j_id], "Nat_ID"=json_res[j_id, 8],"Year_Built"=json_res[j_id, 9], 
                    "Capacity"=cap, "Storage"=res_mat[,1])
  names(reservoirs[[i]]$Storage) <- strftime(week_time, "%Y%m%d")
}

reservoirs[rmv_station] <- NULL
cat('stations dropped:');cat(sum(rmv_station))
json <- toJSON(reservoirs)

cat(json,file = '../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')

