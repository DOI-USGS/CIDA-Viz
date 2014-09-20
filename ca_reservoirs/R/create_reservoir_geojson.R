
library(sp)
library(rgdal)

reservoirs = read.table('../Data/ca_reservoirs.csv', sep=',', header=TRUE)

use_crs = CRS("+proj=longlat +datum=WGS84")

res.spdf = SpatialPointsDataFrame(SpatialPoints(as.matrix(reservoirs[,c(5,4)])), 
                       proj4string=use_crs, data=reservoirs[,c(-5,-4)])


writeOGR(res.spdf, 'tmp', layer='', driver="GeoJSON")
file.rename('tmp','../Data/ca_reservoirs.geojson')
