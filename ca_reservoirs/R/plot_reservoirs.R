plot_cap <- function(capacities, perc_full, date){
  
  tot_cap <- sum(capacities, na.rm = T)
  
  gap <- 0.35/(length(!is.na(capacities) - 1))
  
  x1 = 0
  par(mai = c(0.2,1,.2,.2), oma = c(0,0,0,0), ps = 16)
  plot(c(NA, 0), c(NA,NA), ylim = c(0, 100), xlim = c(0, 1), 
       axes = F, ylab = 'Reservoir capacity (%)', xlab = '', 
       xaxs="i",yaxs="i")
  
  for (i in 1:length(capacities)){
    x2 = x1 + capacities[i]/tot_cap
    if (!is.na(capacities[i])){
      y2 <- min(c(perc_full[i]*100, 100))
      polygon(c(x1, x2, x2, x1), c(0,0,100, 100), 
              col = 'grey90', border = 'grey90')
      polygon(c(x1, x2, x2, x1), c(0,0,y2,y2), 
              col = 'blue', border = 'blue')
      x1 = x2 + gap
    }
    
  }
  axis(side = 2, at = seq(0,100,25))
  axis(side = 1, at = c(0, 1.5))
  txt <- paste0(format(as.Date(date, "%Y%m%d"), '%Y-%m', pos = 2), '-01')
  
  text(.88, 92, txt, cex = 2, col = 'grey65')
}

library(jsonlite)
library(animation)
file_json <- fromJSON(file = '../storage_data/reservoir.json')

repeats = 5
use_dates <- names(tail(file_json[[1]]$Storage, 199)) # was 194

plot_out <- function(use_dates){
  tot_res <- length(file_json)
  
  res_cap <- vector(length = tot_res)
  res_perc <- vector(length = tot_res)
  for (d_i in 1:length(use_dates)){
    
  
    for (i in 1:tot_res){
      res_cap[i] <- as.numeric(file_json[[i]]$Capacity)
      vl <- file_json[[i]]$Storage[use_dates[d_i]][[1]]
      if (!is.null(vl)){
        res_perc[i] <- as.numeric(vl)/res_cap[i]
      }
    }
    plot_cap(res_cap, res_perc, use_dates[d_i])
  }
  for (i in 1:repeats){
    plot_cap(res_cap, res_perc, use_dates[d_i])
  }
}

file.remove("cida_viz.gif")
saveGIF({plot_out(use_dates)
  
}, movie.name = "cida_viz.gif", interval = 0.1, nmax = length(use_dates), ani.width = 800, 
ani.height = 250)
