res_json <- fromJSON('../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')

plot(c(0,NA),c(NA,0),ylim=c(0,4552000),xlim = c(0,4552000), ylab = 'Observed max',xlab='Reported capacity')
for (i in 1:length(res_json[[1]])){
  cap <- res_json$Capacity[i]
  max_obs <- max(res_json$Storage[i,])
  print(max_obs)
  print(cap)
  cat('\n')
  points(max_obs,cap)
}
abline(0,1)