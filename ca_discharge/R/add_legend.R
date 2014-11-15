add_legend <- function(g_id, col_vec, num_txt, desc_txt){
  
  x_txt <- 215
  y_txt_t <- 35
  
  x_dot <- 205
  y_dot_t <- 30
  
  y_spc <- 20
  
  for (i in 1:length(col_vec)){
    tran <- paste0('translate(',as.character(x_txt),',',as.character(y_txt_t+(i-1)*y_spc),')')
    t_id <- paste0('t_',as.character(col_vec[i]))
    c_id <- paste0('c_',as.character(col_vec[i]))
    mve <- paste0("ShowTooltip(evt,'",desc_txt[i],"');document.getElementById('",t_id,"').setAttribute('opacity', '0');")
    out <- paste0("HideTooltip(evt);document.getElementById('",t_id,"').setAttribute('opacity', '1');")
    col <- get_mark_col(col_vec[i])
    txt_nd <- newXMLNode("text", newXMLTextNode(num_txt[i]), 
                         attrs = c('id' = t_id, 'text-anchor'="left", 
                                   transform=tran))
    c_nd <- newXMLNode("circle", 
                       attrs = c(id = c_id,
                                 cx=as.character(x_dot), cy=as.character(y_dot_t+(i-1)*y_spc),
                                 r = "5",
                                 style = paste0("fill:",col,"; fill-opacity: 0.9"),
                                 stroke="black", "stroke-width"="0.5",
                                 onmousemove=mve,
                                 onmouseout=out))
    g_id <- addChildren(g_id, txt_nd, c_nd)
  }
  
  
  return(g_id)
}