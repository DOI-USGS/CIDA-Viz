

sites = read.csv('../sites.csv', as.is=TRUE)
all_data = data.frame()

for(i in 1:nrow(sites)){
  fname = paste0('../data_sane/', sites$Station[i], '.csv')
  
  data = read.table(fname, sep=',', header=TRUE, as.is=TRUE)
  if(nrow(data)==0){
    next
  }
  data$site = sites$Station[i]
  all_data = rbind(all_data, data)
}

library(data.table)
all_data = data.table(all_data)

all_data[,week:=ceiling(as.POSIXlt(datetime)$yday/7)]
all_data = all_data[week < 25,]
all_data[,year:=ceiling(as.POSIXlt(datetime)$year+1900)]
all_data[,month:=ceiling(as.POSIXlt(datetime)$mon)]


