log_tran_x <- function(val, x_crt, x_lim){
  
  if (missing(x_crt)){
    x_crt = c(28, 528)
  }
  if (missing(x_lim)){
    x_lim = c(0.01, 200)
  }
  log_val <- log10(val)
  log_lim <- log10(x_lim)
  log_rng <- diff(log_lim)
  px_rng = diff(x_crt)
  px_rat <- px_rng/log_rng # ratio of px per log unit val
  
  x_px <- x_crt[1]+(log_val-log_lim[1])*px_rat
  
  # gets value and bounds of x, returns "pixel-space" value for x
  
  return(x_px)
  
}
log_tran_y <- function(val, y_crt, y_lim){
  
  if (missing(y_crt)){
    y_crt = c(500, 0)
  }
  if (missing(y_lim)){
    y_lim = c(0.01, 200)
  }
  log_val <- log10(val)
  log_lim <- log10(y_lim)
  log_rng <- diff(log_lim)
  px_rng = diff(rev(y_crt))
  px_rat <- px_rng/log_rng # ratio of px per log unit val
  
  y_px <- y_crt[1]-(log_val-log_lim[1])*px_rat
  
  # gets value and bounds of x, returns "pixel-space" value for x
  
  return(y_px)
  
}