## Scrape snow data


base_url = 'http://www.wcc.nrcs.usda.gov/nwcc/rgrpt?station=%s&report=snowmonth_hist'

sites = read.csv('../sites.csv', as.is=TRUE)

for(i in 1:nrow(sites)){
  url = sprintf(base_url, sites$Station[i])
  
  download.file(url, fname)
}

for(i in 1:nrow(sites)){
  
  fname = paste0('../data_raw/', sites$Station[i], '.csv')
  data = read.table(fname, as.is=TRUE, sep=',', header=TRUE, skip=8)
  
  ##sorry, the below code is ugly. 
  #january c(1,2,4)
  #Feb c(1,5,7)
  #Mar c(1,8,10)
  #Apr c(1,11,13)
  #May c(1,14,16)
  #Jun c(1,17,19)
  fixed = data.frame()
  tmp = data[,c(1,2,4)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp)
  tmp = data[,c(1,5,7)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp) 
  tmp = data[,c(1,8,10)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp)
  tmp = data[,c(1,11,13)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp)
  tmp = data[,c(1,14,16)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp)
  tmp = data[,c(1,17,19)]
  names(tmp) = c('year', 'date', 'snow.water.eq.inches')
  fixed = rbind(fixed, tmp)
  
  
  #now lets finalize this format and save it
  fixed = fixed[complete.cases(fixed),]
  fixed$datetime = strptime(paste(fixed$year,fixed$date), '%Y %b %d')
  fixed = fixed[,c(4,3)]
  fixed = fixed[order(fixed$datetime),]
  
  fname = paste0('../data_sane/', sites$Station[i], '.csv')
  write.table(fixed, fname, sep=',', row.names=FALSE, col.names=TRUE)
}





