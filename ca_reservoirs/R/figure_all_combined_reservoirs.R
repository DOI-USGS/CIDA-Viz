## Lets look at overall storage in all reservoirs

sites = read.csv('../Data/ca_reservoirs.csv', as.is=TRUE)
all.data = data.frame()
for(i in 1:nrow(sites)){
  fname = paste0('../storage_data/', sites$ID[i], '.csv')
  if(!file.exists(fname)){
    next
  }
  
  data = read.csv(fname, as.is=TRUE)
  
  if(nrow(data) < 1500){
    next
  }
  names(data) = c("Date", sites$ID[i])
  if(nrow(all.data) == 0){
    all.data = data   
  }else{
    all.data = merge(all.data, data, by="Date", all=TRUE)
  }
}

## TODO: Fix this, currently doesn't handle lakes with missing data
all.dates = as.POSIXct(all.data$Date)
all.vols = apply(as.matrix(all.data[,-1]), 1, sum, na.rm=TRUE)

png('../storage_plots/figure_all_CA_storage.png', width=1200, height=900, res=150)
plot(all.dates, all.vols/810713.194, ylim=c(12,38), ylab=expression(Storage~km^3), xlab='')
dev.off()

