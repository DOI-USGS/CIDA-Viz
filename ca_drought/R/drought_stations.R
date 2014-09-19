get_drought_data <- function(station_id){
  library('jsonlite')
  library('RCurl')
  ##'droughtatlas.unl.edu/Services/DroughtMonitor/Timeseries/045721/20000101_20140916/county/usdm_timeseries.csv'
  
}

get_drought_stations <- function(file){
  library('jsonlite')
  json <- readLines(con <- file('../data/drought_altas_stations.json'))
  close(con)
  stations <- fromJSON(json)
  return(stations)
}