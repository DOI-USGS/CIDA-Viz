dis_points <- function(){
  radius = 10
  
  dat <- read.csv('../Data/disStats.csv')
  
  points <- data.frame(meanDis = dat$meanDis, todayDis = dat$todayDis, 
                       r = rep(radius, nrow(dat)), text = dat$siteName, id = dat$STAID,
                       sitex = dat$lon, sitey = dat$lat, 
                       p_10 = dat$percent10, p_25 = dat$percent25, p_75 = dat$percent75, p_90 = dat$percent90)
  rmv_i <- is.na(points$meanDis)
  
  points <- points[!rmv_i, ]
  
  return(points)
}
