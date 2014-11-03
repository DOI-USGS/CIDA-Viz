dis_points <- function(){
  radius = 10
  
  dat <- read.csv('../Data/disStats.csv')
  
  points <- data.frame(meanDis = dat$meanDis, todayDis = dat$todayDis, 
                       r = rep(radius, nrow(dat)), text = dat$siteName, id = dat$STAID,
                       sitex = dat$lon, sitey = dat$lat)
  rmv_i <- is.na(points$meanDis)
  
  points <- points[!rmv_i, ]
  
  return(points)
}

transform_pts <- function(x, y){
  x <- log(x)*25+378
  y <- 150-log(y)*25
  return(data.frame(x,y))
}