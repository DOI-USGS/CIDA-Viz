get_crop_nums <- function(crop_name = 'Navel_Oranges', years_out=seq(2009,2014)){
  
  fn <- paste0('../data/ca_price_vs_pct_severe_di.csv')
  dat <- read.csv(file = fn, sep = ',')
  
  values <- as.numeric(unlist(dat[eval(paste0(crop_name,'.Avg.Price'))]))
  years <- dat$year_str
  
  drought <- dat$Percent.of.CA.in.Severe.Drought
  
  use_i <- years %in% years_out
  anomoly <- values - mean(values[use_i])
  
  df <- data.frame('anomoly' = anomoly[use_i], 'drought' = drought[use_i], 'years' = as.numeric(years[use_i]))
  return(df)
}
