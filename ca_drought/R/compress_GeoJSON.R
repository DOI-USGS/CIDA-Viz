library('jsonlite')
library('rgeos')
library('rgdal')
library('maps')
compress_gjson <- function(time_st){
  map = readOGR(drought_json, "OGRGeoJSON")
  drought_json = paste0('../../Vizzies/public_html/data/drought_shp/USDM_',time_st,'.json')
  drought_low <- paste0('../data/USDM_',time_st,'_low.json')
  
  map_low <- gSimplify(map,tol = .03, topologyPreserve=TRUE) ## simplify
  
  spp <- SpatialPolygonsDataFrame(map_low, 
                                  data=as.data.frame(slot(map, "data")))
  
  
  writeOGR(obj = spp,dsn = drought_low, layer = 'drought',driver = 'GeoJSON')
}




res_time <- fromJSON(txt = '../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')
times <- names(res_time$Storage)
for (i in 1:length(times)){
  compress_gjson(times[i])
}
