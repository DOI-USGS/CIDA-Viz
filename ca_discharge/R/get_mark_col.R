get_mark_col <- function(x,y, p){
  
  if (missing(p)){
    p = y/x*50 # temporary junk. Will give actually p
  }
  
  
  red = "#752121"
  orange = "#FFA400"
  green = "#00FF00"
  l_blue = "#40DFD0"
  blue = "#0000FF"
  
  
  if (p < 10){
    col = red
  } else if (p >= 10 & p < 25){
    col = orange
  } else if (p >= 25 & p <= 75){
    col = green
  } else if (p > 75 & p <= 90){
    col = l_blue
  } else {
    col = blue
  }
  
  return(col)
}