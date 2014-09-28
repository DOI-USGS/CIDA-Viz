create_hybrid_svg <- function(time_st = "20140916"){
  library('jsonlite')
  library('rgeos')
  library('rgdal')
  library('maps')
  
  plot_cap <- function(capacities, perc_full, date){
    
    tot_cap <- sum(capacities, na.rm = T)
    
    gap <- 0.35/(length(!is.na(capacities) - 1))
    
    x1 = 0
    plot(c(NA, 0), c(NA,NA), ylim = c(0, 100), xlim = c(0, 1), 
         axes = F, ylab = '', xlab = '', 
         xaxs="i",yaxs="i")
    
    for (i in 1:length(capacities)){
      x2 = x1 + capacities[i]/tot_cap
      if (!is.na(capacities[i])){
        y2 <- min(c(perc_full[i]*100, 100))
        polygon(c(x1, x2, x2, x1), c(0,0,100, 100), 
                col = 'grey90', border = 'grey90')
        polygon(c(x1, x2, x2, x1), c(0,0,y2,y2), 
                col = rgb(80,146,204,trans_drought,maxColorValue = 255), border = NA)
        x1 = x2 + gap
      }
      
    }
    axis(side = 2, at = seq(0,100,25), tck= 0.01)
    par(mgp=c(1,.05,0))
    title(ylab="Reservoir capacity (%)")
    par(mgp=c(.1,.05,0))
    axis(side = 1, at = c(-1, 1.5))
    title(xlab="California reservoirs sorted by elevation")
    
    txt <- paste0(format(as.Date(date, "%Y%m%d"), '%Y-%m', pos = 2), '-01')
    
    text(.8, 90, txt, cex = 2.5, col = 'grey65')
  }
  
  
  trans_drought <<- 150
  drought_json = paste0('../../Vizzies/public_html/data/drought_shp/USDM_',time_st,'.json')
  res_time <- fromJSON(txt = '../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')
  res_json = '../../Vizzies/public_html/data/reservoirs/ca_reservoirs.geojson'
  res = readOGR(res_json, "OGRGeoJSON")
  
  ### ---- check match to same order!!! -----
  storage <- as.numeric(res_time$Storage[[time_st]])
  capacity <- res_time$Capacity
  
  svg_nm <- paste0('../../Vizzies/public_html/data/reservoir_drought/res_hybrid_',time_st,'.svg')
  svg(svg_nm, width = 7, height = 3,antialias = 'none')
  panels = matrix(c(1,1,1,2,2,2,2,2),nrow=1)
  layout(panels)
  par(omi = c(0,0,0,0),mai=c(0,0,0,0), mgp=c(.6,.01,0), ps = 14)
  map('state',c('California'))
  map = readOGR(drought_json, "OGRGeoJSON")
  plot(map, col = c(rgb(255,255,68,trans_drought,maxColorValue = 255),
                    rgb(255,211,133,trans_drought,maxColorValue = 255),
                    rgb(242,0,0,trans_drought,maxColorValue = 255),
                    rgb(121,0,0,trans_drought,maxColorValue = 255)), border = 'grey30', add = T)
  
  
  points(res,cex = (capacity/4552000)*10,col = 'grey30', lwd=2)
  points(res,cex = (storage/4552000)*10, pch = 16,
         col = rgb(80,146,204,trans_drought,maxColorValue = 255), 
         bg = rgb(80,146,204,trans_drought,maxColorValue = 255))
  
  par(mai = c(0.15,.25,.15,.0))
  
  plot_cap(capacity,storage/capacity,time_st)
  
  dev.off()
}
library('jsonlite')
res_time <- fromJSON(txt = '../../Vizzies/public_html/data/reservoirs/reservoir_storage.json')
times <- names(res_time$Storage)
for (i in 1:length(times)){
  create_hybrid_svg(times[i])
}
