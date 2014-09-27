get_crop_nums <- function(crop_name = 'Oranges', years_out=seq(2011,2014)){
  
  fn <- paste0('../data/ca_price_vs_di.csv')
  dat <- read.csv(file = fn, sep = ',')
  
  values <- as.numeric(unlist(dat[eval(paste0(crop_name,'.Avg.Price'))]))
  years <- substr(as.character(dat$summer),start = 17, stop = nchar(as.character(dat$summer)[1]))
  anomoly <- values - mean(values)
  drought <- dat$Percent.of.CA.in.Severe.Drought
  df <- data.frame('anomoly' = anomoly, 'drought' = drought, 'years' = as.numeric(years))
  return(df)
}
