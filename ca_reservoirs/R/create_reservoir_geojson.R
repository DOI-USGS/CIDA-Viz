
library(sp)
library(rgdal)
library(jsonlite)
res_json <- fromJSON('../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')

use_crs = CRS("+proj=longlat +datum=WGS84")

coord_mat <-data.frame(Longitude= res_json$Longitude,Latitude = res_json$Latitude)
use_nms <- names(res_json)[!names(res_json) %in% c('Longitude','Latitude','Storage')]
att_mat <- data.frame(res_json[use_nms[1]]) # d.f init
names(att_mat) <- use_nms[1]

for (i in 2:length(use_nms)){
  nm <- use_nms[i]
  vl <- res_json[nm]
  df <- data.frame(res_json[use_nms[i]])
  names(df) <- use_nms[i]
  att_mat<-cbind(att_mat,df)
}

res.spdf = SpatialPointsDataFrame(SpatialPoints(coord_mat), 
                       proj4string=use_crs, data=att_mat)


writeOGR(res.spdf, 'tmp', layer='', driver="GeoJSON")
file.rename('tmp','../../Vizzies/public_html/data/reservoirs/ca_reservoirs.geojson')
