add_ticks <- function(g_id, ticks, y_crt, x_crt, y_lim, x_lim, minor_ticks){
  
  title_bmp_x = 33
  title_bmp_y = 25
  tckL_bmp_x = 16
  tckL_bmp_y = 5
  ticks <- ticks[ticks >= x_lim[1] & ticks <= x_lim[2]]
  minor_ticks <- minor_ticks[minor_ticks >= x_lim[1] & minor_ticks <= x_lim[2]]
  t_len = -7
  m_t_len = -3
  x_base = as.character(y_crt[1])
  x_lab = as.character(y_crt[1]+tckL_bmp_x)
  x_tick = as.character(y_crt[1]+t_len)
  x_tick_m <- as.character(y_crt[1]+m_t_len)
  y_base = as.character(x_crt[1])
  y_lab = as.character(x_crt[1]-tckL_bmp_y)
  y_tick = as.character(x_crt[1]-t_len)
  y_tick_m <- as.character(x_crt[1]-m_t_len)
  for (i in 1:length(ticks)){
    x_loc <- as.character(log_tran_x(ticks[i], x_crt, x_lim))
    pth_x <- newXMLNode("line", attrs = c(x1 = x_loc, y1 = x_base, x2 = x_loc, y2 = x_tick,
                                        style = "stroke:black;stroke-width:1.5"))
    x_txt <- newXMLNode("text", newXMLTextNode(as.character(ticks[i])),
                        attrs = c('text-anchor'="middle", 
                                  transform=paste0("translate(",x_loc, ",", x_lab, ")")))
      
    y_loc <- log_tran_y(ticks[i], y_crt, y_lim)
    
    y_txt <- newXMLNode("text", newXMLTextNode(as.character(ticks[i])),
                        attrs = c('text-anchor'="middle", 
                                  transform=paste0("translate(",y_lab, ",", y_loc, ")rotate(270)")))
    
    pth_y <- newXMLNode("line", attrs = c(x1 = y_base, y1 = y_loc, x2 = y_tick, y2 = y_loc,
                                          style = "stroke:black;stroke-width:1.5"))
    g_id <- addChildren(g_id, pth_x, pth_y, x_txt, y_txt)
  }
  for (i in 1:length(minor_ticks)){
    x_loc <- as.character(log_tran_x(minor_ticks[i], x_crt, x_lim))
    pth_x <- newXMLNode("line", attrs = c(x1 = x_loc, y1 = x_base, x2 = x_loc, y2 = x_tick_m,
                                          style = "stroke:black;stroke-width:1.5"))
    y_loc <- log_tran_y(minor_ticks[i], y_crt, y_lim)
    pth_y <- newXMLNode("line", attrs = c(x1 = y_base, y1 = y_loc, x2 = y_tick_m, y2 = y_loc,
                                          style = "stroke:black;stroke-width:1.5"))
    g_id <- addChildren(g_id, pth_x, pth_y)
    
  }
  
  # labels
  
  x_cent <- as.character(mean(x_crt))
  x_title <- as.character(y_crt[1] +  title_bmp_x)
  y_cent <- as.character(mean(y_crt))
  y_title <- as.character(as.numeric(x_crt[1])- title_bmp_y)
  txt_n <- newXMLNode("tspan",newXMLTextNode('Historical average streamflow (cubic feet per second)'))
  
  x_ax <- newXMLNode("text",
                     attrs = c('text-anchor'="middle", transform=paste0("translate(", x_cent, ",", x_title,")")))
  x_ax <- addChildren(x_ax,txt_n)
  txt_n <- newXMLNode("tspan",newXMLTextNode('Current streamflow (cubic feet per second)'))
  
  y_ax <- newXMLNode("text",
                     attrs = c('text-anchor'="middle", 
                               transform=paste0("translate(",y_title,",",y_cent,")rotate(270)")))
  y_ax <- addChildren(y_ax, txt_n)
  
  g_id <- addChildren(g_id, y_ax, x_ax)
  return(g_id)
}

minor_ticks <- function(){
  e_rng <- seq(-4,4)
  p_rng <- seq(2,9)
  ticks <- vector(length= (length(e_rng)*length(p_rng)))
  cnt = 1
  for (j in 1:length(e_rng)){
    e = e_rng[j]
    for (i in 1:length(p_rng)){
      p = p_rng[i]
      num <- paste0(as.character(p),'e', as.character(e))
      ticks[cnt] = as.numeric(num)
      cnt = cnt+1
    }
  }
  return(ticks)
}