ca_crop_viz <- function(username,key,plot_names,plot_colors){
  library(plotly)
  py <- plotly(username=username, key=key)
  

  data <- build_list(plot_names,plot_colors)
  layout <- list(
    title = "Agricultural output cost data (August)", 
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

build_list <- function(plot_names,plot_colors){
  
  plot_list <- vector('list', length=length(plot_names))
  
  for (i in 1:length(plot_names)){
    crop_name <- plot_names[i]
    yrs <- seq(2007,2014)
    dates <- as.Date(paste(yrs,rep(08,length(yrs)), rep(15,length(yrs)),sep='-'))
    y_vals <- get_crop_nums(crop_name,yrs)
    x_vals <- multi_layer_vals(as.Date(dates))
    plot_list[[i]] <- list(
      x = x_vals,
      y = y_vals, 
      mode = "markers", 
      name = paste(toupper(substring(crop_name, 1,1)), substring(crop_name, 2),
                   sep="", collapse=" "),
      text = as.character(seq(2011, 2014)),
      marker = list(
        color = plot_colors[i], 
        size = 18, 
        line = list(
          color = "white", 
          width = 0.5,
          size = 18
        )
      ), 
      type = "scatter"
    )
  }
  return(plot_list)
}

source("get_crop_nums.R")
source("get_drought_idx.R")
plot_names = c('oranges','lemons','grapes','lettuce')
plot_colors = c("rgb(255, 153, 0)", "rgb(255, 255, 150)", "rgb(68, 28, 82)", "rgb(0, 255, 128)")

ca_crop_viz('jordansread','$$$$',plot_names,plot_colors)
