library(rjson)
res_json <- fromJSON('../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')

plot(c(0,NA),c(NA,0),ylim=c(-1000,4552000),xlim = c(-1000,4552000), ylab = 'Observed max',xlab='Reported capacity')
for (i in 1:length(res_json)){
  cat(i);cat('\n')
   cap <- res_json[[i]]$Capacity
   max_obs <- max(as.numeric(res_json[[i]]$Storage))
   print(max_obs)
   print(cap)
   cat('\n')
   points(max_obs,cap)
   points(min_obs,cap)
}
abline(0,1)
