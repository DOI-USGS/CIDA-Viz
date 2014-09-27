#get_fire_output_weekly_geojson.R

library(sp)
library(rgdal)
library(rgeos)

## load
# Download shapefile data from FTP server using external client

## Unpack the data
to_untar = Sys.glob('../data_shp/*.tar.gz')
for(i in 1:length(to_untar)){
	untar(to_untar[i], exdir = '../data_shp')
}


## Load shape data and output as JSON

makeUniform<-function(SPDF, pref){
  newSPDF<-spChFIDs(SPDF,as.character(paste(pref,rownames(as(SPDF,"data.frame")),sep="_")))
  return(newSPDF)
}


get_all_year = function(year){
  to_convert = Sys.glob(paste0('../data_shp/*A', year, '*.shp'))
  
  ca_outline = readOGR('../..', 'tl_2013_california')
  all.data = NA
  for(j in 1:length(to_convert)){
    
    layer = basename(to_convert[j])
    layer = substr(layer, 0, nchar(layer)-4)
    year = as.numeric(substr(layer, 15,18))
    data = readOGR(dirname(to_convert[j]), layer)
    data$Year = year
    data$date = strptime(paste0(data$Year, data$BurnDate), '%Y%j')
    
    data = makeUniform(data, as.character(j))
    if(is.na(all.data)){
      all.data = data
    }else{
      all.data = rbind(all.data, data)
    }
  }
  
  
  to.drop = c()
  for(i in 1:nrow(all.data)){
    
    if(gIntersects(ca_outline, all.data[i,])){
      #nothing
      
    }else{
      to.drop = c(to.drop, i*-1)
    }
  }
  
  snip.data = all.data[to.drop, ]
  
  return(snip.data)

}


to.match = Sys.glob('../../Vizzies/public_html/data/drought_shp/USDM*.json')

starts = strptime(substr(basename(to.match), 6,13), '%Y%m%d')

load.year = NA

for(i in 2:length(starts)){
  year = as.POSIXlt(starts[i])$year + 1900
  if(is.na(load.year) | year != load.year){
    data = get_all_year(year)
    load.year = as.POSIXlt(starts[i])$year + 1900
  }
  if(!any(data$date > starts[i-1] & data$date <= starts[i])){
    next
  }
  
  to.save = data[data$date > starts[i-1] & data$date <= starts[i], ]
  
  writeOGR(to.save, 'tmp', layer="sp", driver="GeoJSON")
  fname = paste0('../data_geojson/FIRE_', format(starts[i], '%Y%m%d'), '.geojson')
  
  file.rename('tmp', fname)
  
}




