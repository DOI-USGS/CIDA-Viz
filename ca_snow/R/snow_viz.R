# use install_github("ropensci/plotly")

snow_viz <- function(user, key){
  library(plotly)
  # Fill in with your personal username and API key
  # or, use this public demo account
  py <- plotly(username=user, key=key)
  
  trace2 <- list(
    x = c('March','April','May','June','July','August','September','October'), 
    y = c(6, 8, 9, 8, 6, 0, NA, NA), 
    mode = "lines+markers", 
    name = "'snow pack (non-drought)'", 
    text = c("non-drought year<br>data from YYY<br>info", 
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info",
             "non-drought year<br>data from YYY<br>info"), 
    
    line = list(shape = "spline", 
                color = 'blue'), 
    type = "scatter"
  )
  
  trace3 <- list(
    x = c('March','April','May','June','July','August','September','October'), 
    y = c(4, 6, 7, 6.2, 4.1, 0, NA, NA), 
    mode = "lines+markers", 
    name = "'snow pack (drought)'", 
    text = c("drought year<br>data from YYY<br>info", 
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info",
             "drought year<br>data from YYY<br>info"), 
    line = list(shape = "spline", 
                color = 'red'),
    type = "scatter"
  )
  
  trace4 <- list(
    x = c('March','April','May','June','July','August','September','October'), 
    y = c(NA, NA, 6, 8, 9, 8, 6, 3.8), 
    mode = "lines+markers", 
    name = "'storage (non-drought)'", 
    text = c(""),
    line = list(shape = "spline", 
                color = 'blue',
                dash = "dot"),
    type = "scatter"
  )
  
  
  trace5 <- list(
    x = c('March','April','May','June','July','August','September','October'), 
    y = c(NA, NA, 4.3, 4.6, 5.1, 4.7, 3.2, 2.3), 
    mode = "lines+markers", 
    name = "'storage (drought)'", 
    text = c(""),
    line = list(shape = "spline", 
                color = 'red', 
                dash = "dot"),
    type = "scatter"
  )
  
  data <- list(trace2, trace3, trace4, trace5)
  layout <- list(legend = list(
    y = 0.5, 
    traceorder = "reversed", 
    font = list(size = 16), 
    yref = "paper"
  ))
  response <- py$plotly(data, kwargs=list(layout=layout, filename="line-shapes", fileopt="overwrite"))
  url <- response$url
  return(url)
}


