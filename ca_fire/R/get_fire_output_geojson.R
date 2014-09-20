

#this damn thing doesn't work for some reason. 
for(i in 2001:2014){
## Download
  
  for(j in c('001','032','060','091','121','152','182','213','244','274','305','335')){
      
    file = sprintf('MCD45monthly.A%i%s.Win03.051.burndate.shapefiles.tar.gz', i, j)
    baseurl = sprintf('ftp://ba1.geog.umd.edu/Collection51/SHP/Win03/%i/', i)
    full_url = paste0(baseurl, file)
    
    tmp = getBinaryURL(full_url, userpwd='user:burnt_data')
  
    out_file = paste0('../data_shp/', file)
    writeBin(tmp, out_file)
  }
}


## load

## snip
to_untar = Sys.glob('../data_shp/*.tar.gz')
for(i in 1:length(to_untar)){
  untar(to_untar[i], exdir = '../data_shp')
}


to_convert = Sys.glob('../data_shp/*.shp')

ca_outline = readOGR('../..', 'tl_2013_california')

for(j in 1:length(to_convert)){

  layer = basename(to_convert[j])
  layer = substr(layer, 0, nchar(layer)-4)
  data = readOGR(dirname(to_convert[j]), layer)
  
    
  #bounding box
  ca.lats = c(32.18, 42.97)
  ca.lons = c(-124.41, -113.32)
  
  to.drop = c()
  for(i in 1:nrow(data)){
    
    #this.center = apply(bbox(data[i,]), 1, mean)
    
    #if(this.center[1] > ca.lons[1] & this.center[1] < ca.lons[2] &
    #     this.center[2] > ca.lats[1] & this.center[2] < ca.lats[2]){
     
    if(gIntersects(ca_outline, data[i,])){
      #nothing
      
    }else{
      to.drop = c(to.drop, i*-1)
    }
  }
  
  snip.data = data[to.drop,]
  
  ##Output as geoJSON
  writeOGR(snip.data, 'tmp', layer="sp", driver="GeoJSON")
  
  file_date = strptime(substr(layer, 15,21), '%Y%j')
  
  geojson_name = paste0('FIRE_', format(file_date, '%Y%m%d'), '.geojson')
  
  file.rename('tmp', paste0('../data_geojson/', geojson_name))
}

unlink('tmp')