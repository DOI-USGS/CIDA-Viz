get_mark_col <- function(discharge, p_10 = 10, p_25 = 25, p_75 = 75, p_90 = 90){
  
  q = discharge
  
  red = "#752121"
  orange = "#FFA400"
  green = "#00FF00"
  l_blue = "#40DFD0"
  blue = "#0000FF"
  
  if (sum(discharge == c(p_10, p_25, p_75, p_90)) > 1){
    return("#FFFFFF")
    # not ranked
  }
  
  if (q < p_10){
    col = red
  } else if (q >= p_10 && q < p_25){
    col = orange
  } else if (q >= p_25 && q <= p_75){
    col = green
  } else if (q > p_75 && q <= p_90){
    col = l_blue
  } else {
    col = blue
  }
  
  return(col)
}