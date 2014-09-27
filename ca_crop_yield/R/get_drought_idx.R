get_drought_idx <- function(layer_name){
  tot_area = 206976224224
  library('rgeos')
  library('sp')
  library('jsonlite')
  
  vals <- fromJSON(paste0('../../Vizzies/public_html/data/drought_shp/',layer_name))
  
  num_d = 4
  areas <- vector(length = num_d )
  for (i in 1:num_d){
    areas[i] <- cumulative_area(vals, i)
    
  }
  
  w0 = 0
  w1 = 1*areas[1]
  w2 = 2*areas[2]
  w3 = 3*areas[3]
  w4 = 4*areas[4]
  
  weighted_idx <- sum(c(w0,w1,w2,w3,w4), na.rm = T)/tot_area
  return(weighted_idx)
}

cumulative_area <- function(vals, drought_i){
  library('rgdal')
  area <- 0
  
  area <- tryCatch({
    num_feat <- length(vals$features[[drought_i]]$geometry$coordinates)
    for (i in 1:num_feat){
      latlong <- unlist(vals$features[[drought_i]]$geometry$coordinates[[1]])
      lon <- latlong[seq(1,length(latlong),2)]
      lat <- latlong[seq(2,length(latlong),2)]
      spPolygons <- SpatialPolygons(list(Polygons(list(Polygon(cbind(lon,lat))), ID="a")))
      spPolygons@proj4string <- CRS("+proj=longlat +ellps=sphere +no_defs")
      
      spPolygons<- spTransform(spPolygons, CRS=CRS("+proj=merc +ellps=GRS80"))
      
      area <- area + gArea(spPolygons)
      return(area)
    }
    
  }, error=function(err){return(0)})

  return(area)
}

nearest_drought_layer <- function(date_in){
  
  layers <- list.files("../../Vizzies/public_html/data/drought_shp/", pattern = ".json")
  layers <- layers[nchar(layers)==18] # only our format of "USDM_YYYYMMDD.json"
  dates_pos <- as.Date(substr(layers,6,13), "%Y%m%d")

  use_i <- which.min(abs(dates_pos-date_in))
  layer_name = layers[use_i]
  return(layer_name)
}

multi_layer_vals <- function(dates){
  
  value_out <- vector(length = length(dates))
  for (j in 1:length(dates)){
    layer <- nearest_drought_layer(dates[j])
    value_out[j] <- get_drought_idx(layer)
  }
  return(value_out)
}
