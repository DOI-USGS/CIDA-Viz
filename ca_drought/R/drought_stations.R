get_drought_data <- function(json_file){
  library('RCurl')
  
  base_url <- 'droughtatlas.unl.edu/Services/DroughtMonitor/Timeseries/'
  start_d <- '20000101'
  end_d <- '20140916'
  stations <- get_drought_stations(json_file)
  for (i in 1:nrow(stations)){
    ID <- as.character(stations$ID[i])
    file_out <- paste0('../data/ca_atlas_',ID,'.csv')
    #start_d <- as.character(stations$StartDate[i]) # apparently the drought indices don't go back as far as the data. 
    post_url <- paste0(base_url,ID,'/',start_d,'_',end_d,'/','county/usdm_timeseries.csv')
    station_txt <- getURL(post_url)
    cat(station_txt, file = file_out, append = FALSE)
  }
  
}

get_drought_stations <- function(json_file){
  library('jsonlite')
  json <- readLines(con <- file(json_file))
  close(con)
  stations <- fromJSON(json)
  return(stations$d)
}

stations_to_csv <- function(json_file){
  stations <- get_drought_stations(json_file)
  
  write.csv(stations, file = '../data/drought_altas_stations.csv')
}

json_file = '../data/drought_altas_stations.json'
stations_to_csv(json_file)
get_drought_data(json_file)
