
library(sp)
library(rgdal)
library(rgeos)
library(raster)

ca_outline = readOGR('../..', 'tl_2013_california')

download_shp = function(date){
	fmt_date = format(date, '%Y%m%d')
	url_pattern = 'http://droughtmonitor.unl.edu/data/shapefiles_m/USDM_%s_M.zip'
	url = sprintf(url_pattern, fmt_date)
	dest = sprintf('../shp/USDM_%s_M.zip', fmt_date)
	to_check = '../../Vizzies/public_html/data/drought_shp/USDM_%s.json'
	if(!file.exists(sprintf(to_check, fmt_date))){
		download.file(url, dest)
		return(TRUE)
	}else{
		return(FALSE)
	}
}

unpack_clip_save_geojson = function(date){
	fmt_date = format(date, '%Y%m%d')
	zipfile = sprintf('../shp/USDM_%s_M.zip', fmt_date)
	unzip(zipfile, exdir='../shp')
	
	data = readOGR('../shp', paste0('USDM_', fmt_date))
	if(is.na(proj4string(data))){
	  # droughtmon did something odd...
	  proj4string(data) <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m
+nadgrids=@null +no_defs"
    data <- spTransform(data, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
	}
	
  data_0buff <- gBuffer(data, byid=TRUE, width=0)
	clipped.data = crop(data_0buff, ca_outline, byid=TRUE)
	clipped.simp = gSimplify(clipped.data, tol = .03, topologyPreserve=TRUE)
	to.save = SpatialPolygonsDataFrame(clipped.simp, clipped.data@data)
	
	writeOGR(to.save, 'tmp', layer="sp", driver="GeoJSON")
	to_rename = '../../Vizzies/public_html/data/drought_shp/USDM_%s.json'
	fname = sprintf(to_rename, fmt_date)
	
	file.rename('tmp', fname)
	
}

add_date_to_indx = function(date){
	library(jsonlite)
	fmt_date = format(date, '%Y%m%d')
	
	times_json = fromJSON('../../Vizzies/public_html/data/drought_shp/times.json')
	#add, check unique, and sort
	times_json$d = sort(unique(c(times_json$d, fmt_date)), decreasing=TRUE)
	
	json_txt = prettify(toJSON(times_json))
	cat(json_txt, file='../../Vizzies/public_html/data/drought_shp/times.json')
}

update_mainJS = function(){
  library(whisker)
  times_json = jsonlite::fromJSON('../../Vizzies/public_html/data/drought_shp/times.json')$d
  timesteps = jsonlite::toJSON(times_json)
  template <- paste(readLines('../data/main.js.mustache'),'collapse'='\n')
  main.js.text <- whisker::whisker.render(template, data = list(timesteps=timesteps))
  cat(main.js.text, file='../../Vizzies/public_html/js/main.js')
}

start = as.Date('2011-01-04')
end = start + as.difftime(ceiling(as.numeric(Sys.Date() - start, units='days')/7)*7, units='days') - 7
all_dates = seq(start, end, by=7)


for(i in 1:length(all_dates)){
	if(download_shp(all_dates[i])){
		unpack_clip_save_geojson(all_dates[i])
		add_date_to_indx(all_dates[i])
		update_mainJS()
	}
}

