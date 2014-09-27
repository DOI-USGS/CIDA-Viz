library(plyr)
library(data.table)
library(jsonlite)

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
all_data[,month:=as.POSIXlt(datetime)$mon+1]

################################################################################
## collect the reservoir data
################################################################################

res.data = fromJSON('../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')

all.dates = strptime(names(res.data$Storage), '%Y%m%d')
all.vols = apply(res.data$Storage, 2, sum)

all_res_data = data.table(data.frame(dates=all.dates, vols=all.vols))

all_res_data[,month:=as.POSIXlt(dates)$mon+1]
all_res_data[,year:=as.POSIXlt(dates)$year+1900]

res.dry.year  = ddply(all_res_data[year==2014,], 'month', function(df){median(df$vols, na.rm=TRUE)})
res.whet.year = ddply(all_res_data[year==2011,], 'month', function(df){median(df$vols, na.rm=TRUE)})
	
################################################################################
##Do the plotting
################################################################################

dry.year = ddply(all_data[year==2014,], 'month', function(df){median(df$snow.water.eq.inches, na.rm=TRUE)})
whet.year = ddply(all_data[year==2011,], 'month', function(df){median(df$snow.water.eq.inches, na.rm=TRUE)})

par(oma=c(1,1,1,3))
plot(dry.year$month, dry.year$V1, type='l', col='red', lwd=2, ylim=c(0,40), xlim=c(0,12), 
		 xlab='', ylab='Average Snowpack (inch equivalents)')
#points(whet.year$month, whet.year$V1, type='o', col='blue', ylim=c(0,40))
lines(whet.year$month, whet.year$V1, type='l', col='blue', ylim=c(0,40), lwd=2)

par(new=TRUE)
plot(res.dry.year$month, res.dry.year$V1/810713.194, ylim=c(0, 32), xlim=c(0, 12), 
		 type='l', yaxt='n', col='red', xlab='', ylab='', lty=2, lwd=2)
par(new=TRUE)
plot(res.whet.year$month, res.whet.year$V1/810713.194, ylim=c(0, 32), xlim=c(0, 12), 
		 type='l', yaxt='n', col='blue', xlab='', ylab='', lty=2, lwd=2)
axis(side=4)
mtext(side=4, text='Storage(km^3)', padj=3)
legend('topright',c('2010-Wet Year', '2014-Dry Year'), lty=1, col=c('blue','red'))


