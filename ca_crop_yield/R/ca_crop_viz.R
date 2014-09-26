ca_crop_viz <- function(username,key){
  library(plotly)
  py <- plotly(username=username, key=key)
  
  trace1 <- list(
    x = c(0.7286253 ,1.619379, 2.92937, 3.424403),
    y = c( 1.268, 1.283, 1.377, 1.467), 
    mode = "markers", 
    name = "Oranges", 
    text = as.character(seq(2011, 2014)),
    marker = list(
      color = "rgb(255, 153, 0)", 
      size = 12, 
      line = list(
        color = "white", 
        width = 0.5
      )
    ), 
    type = "scatter"
  )
  data <- list(trace1)
  layout <- list(
    title = "Agricultural output cost data", 
    xaxis = list(
      title = "Statewide drought index (0-4)", 
      showgrid = FALSE, 
      zeroline = FALSE
    ), 
    yaxis = list(
      title = "Price ($ per pound)", 
      showline = FALSE
    )
  )
  response <- py$plotly(data, kwargs=list(layout=layout, filename="line-style", fileopt="overwrite"))
  url <- response$url
  return(url)
}
