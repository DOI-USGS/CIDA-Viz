get_crop_nums <- function(crop_name = 'oranges', years_out=seq(2011,2014)){
  fn <- paste0('../data/produce/',crop_name,'.csv')
  dat <- read.csv(file = fn, sep = ',')
  
  num_lines <- length(dat$Consumer.Price.Index...Average.Price.Data)
  years <- as.numeric(as.character(dat$Consumer.Price.Index...Average.Price.Data[9:num_lines]))
  
  # August is X.7
  values <- as.numeric(as.character(dat$X.7[9:num_lines]))
  
  values <- values[years %in% years_out] # assumes data are in order
  
  return(values)
}
