drought_UTM <- function(time_st = "20140916"){
  coord_ref <- " +proj=utm +zone=11 +ellps=WGS84 +datum=WGS84 +units=m +no_defs +towgs84=0,0,0"
  
  y_lim = c(3599803, 4674810.2)
  x_lim = c(-128854, y_lim[2]-y_lim[1])
  library('jsonlite')
  library('rgeos')
  library('rgdal')
  library('maps')
  library('maptools')
  trans_drought <- 150
  
  drought_json = paste0('../../Vizzies/public_html/data/drought_shp/USDM_',time_st,'.json')
  
  svg_nm <- paste0('../Figures/drought_',time_st,'.svg')
  svg(filename = svg_nm, width = 4, height = 4)
  par(omi = c(0,0,0,0),mai=c(0,0,0,0))
  usa <- map("state", fill = TRUE, resolution = 0, plot = F)
  
  IDs <- sapply(strsplit(usa$names, ":"), function(x) x[1])
  usa <- map2SpatialPolygons(usa, IDs=IDs, proj4string=CRS("+proj=longlat +datum=WGS84"))
  ca_i <- names(usa) == 'california'
  ca = usa[ca_i, ]
  drought_lyr = readOGR(drought_json, "OGRGeoJSON")
  
  lyr_UTM <- spTransform(drought_lyr,CRS(coord_ref))
  ca_UTM <- spTransform(ca,CRS(coord_ref))
  plot(ca_UTM, xlim = x_lim, ylim = y_lim)
  
  plot(lyr_UTM, col = c(rgb(255,255,68,trans_drought,maxColorValue = 255),
                    rgb(255,211,133,trans_drought,maxColorValue = 255),
                    rgb(242,0,0,trans_drought,maxColorValue = 255),
                    rgb(121,0,0,trans_drought,maxColorValue = 255)), border = 'grey30', add = T, 
       xlim = x_lim, ylim = y_lim)
  dev.off()
  lyr_info <- list('coord_ref' = coord_ref, 'ylim'=y_lim, 'xlim'=x_lim, 'file_nm' = svg_nm )
  return(lyr_info)
}