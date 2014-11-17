add_CA <- function(g_id, points, x_crd, y_crd, time_st, def_opacity){

  lyr_info <- drought_UTM(time_st)
  
  g_id <- get_CA_paths(g_id, lyr_info, x_crd, y_crd)
  
  col_vec = c(9, 12, 50, 79, 91)
  num_txt = c('<10', '10-24', '25-75', '76-90', '>90%')
  desc_txt = c('well below normal', 'below normal', 'normal', 'above normal', 'well above normal')
  g_id <- add_legend(g_id, col_vec, num_txt, desc_txt)
  
  
  for (i in 1:length(points[[1]])){
    site_id <- paste0('site_',points$id[[i]])
    nwis_id <- paste0('nwis_',points$id[[i]])
    link_site <- paste0("window.open('http://waterdata.usgs.gov/ca/nwis/uv?site_no=",points$id[[i]],"','_blank')")
    mouse_move_txt <- paste0("ShowTooltip(evt, '", points$text[[i]], "')")
    rel_pnt <- WGS84_to_svg(c(points$sitex[[i]], points$sitey[[i]]), lyr_info)
    pnts <- box_pnts(rel_pnt, x_crd, y_crd)
    col <- get_mark_col(discharge = points$todayDis[[i]], 
                        p_10 = points$p_10[[i]], p_25 = points$p_25[[i]],
                        p_75 = points$p_75[[i]], p_90 = points$p_90[[i]])
    pth <- newXMLNode("circle", 
                      attrs = c(id = site_id, 
                                cx=pnts[1], cy=pnts[2], r = "3",
                                fill=col,'fill-opacity' = "0.7",stroke="black", "stroke-width"="0.5",
                                onmouseover=paste0("MakeOpaque(evt); document.getElementById('",nwis_id,"').setAttribute('fill-opacity', '1')"),
                                onmousemove=mouse_move_txt,
                                onclick=link_site,
                                onmouseout=paste0("HideTooltip(evt);evt.target.setAttribute('fill-opacity', '0.7');document.getElementById('",
                                                  nwis_id,"').setAttribute('fill-opacity','",def_opacity,"')")))

    g_id <- addChildren(g_id, pth)
  }
  return(g_id)
}

add_usgs <- function(g_id){
  pth_1 <- newXMLNode("path", attrs = c(id = 'USGS', d="m234.95 15.44v85.037c0 17.938-10.132 36.871-40.691 36.871-27.569 0-40.859-14.281-40.859-36.871v-85.04h25.08v83.377c0 14.783 6.311 20.593 15.447 20.593 10.959 0 15.943-7.307 15.943-20.593v-83.377h25.08m40.79 121.91c-31.058 0-36.871-18.27-35.542-39.03h25.078c0 11.462 0.5 21.092 14.282 21.092 8.472 0 12.62-5.482 12.62-13.618 0-21.592-50.486-22.922-50.486-58.631 0-18.769 8.968-33.715 39.525-33.715 24.42 0 36.543 10.963 34.883 36.043h-24.419c0-8.974-1.492-18.106-11.627-18.106-8.136 0-12.953 4.486-12.953 12.787 0 22.757 50.493 20.763 50.493 58.465 0 31.06-22.75 34.72-41.85 34.72m168.6 0c-31.06 0-36.871-18.27-35.539-39.03h25.075c0 11.462 0.502 21.092 14.285 21.092 8.475 0 12.625-5.482 12.625-13.618 0-21.592-50.494-22.922-50.494-58.631 0-18.769 8.969-33.715 39.531-33.715 24.412 0 36.536 10.963 34.875 36.043h-24.412c0-8.974-1.494-18.106-11.625-18.106-8.144 0-12.955 4.486-12.955 12.787 0 22.757 50.486 20.763 50.486 58.465 0 31.06-22.75 34.72-41.85 34.72m-79.89-46.684h14.76v26.461l-1.229 0.454c-3.816 1.332-8.301 2.327-12.453 2.327-14.287 0-17.943-6.645-17.943-44.177 0-23.256 0-44.348 15.615-44.348 12.146 0 14.711 8.198 14.933 18.107h24.981c0.198-23.271-14.789-36.043-38.42-36.043-41.021 0-42.52 30.724-42.52 60.954 0 45.507 4.938 63.167 47.12 63.167 9.784 0 25.36-2.211 32.554-4.18 0.436-0.115 1.212-0.596 1.212-1.216v-59.598h-38.612v18.09", 
                                        style = "fill:rgb(40%,40%,40%); fill-opacity: 0.2", transform="translate(419,458)scale(0.25)"))
  pth_2 <- newXMLNode("path", attrs = c(id = 'waves', d="m48.736 55.595l0.419 0.403c11.752 9.844 24.431 8.886 34.092 2.464 6.088-4.049 33.633-22.367 49.202-32.718v-10.344h-116.03v27.309c7.071-1.224 18.47-0.022 32.316 12.886m43.651 45.425l-13.705-13.142c-1.926-1.753-3.571-3.04-3.927-3.313-11.204-7.867-21.646-5.476-26.149-3.802-1.362 0.544-2.665 1.287-3.586 1.869l-28.602 19.13v34.666h116.03v-24.95c-2.55 1.62-18.27 10.12-40.063-10.46m-44.677-42.322c-0.619-0.578-1.304-1.194-1.915-1.698-13.702-10.6-26.646-5.409-29.376-4.116v11.931l6.714-4.523s10.346-7.674 26.446 0.195l-1.869-1.789m16.028 15.409c-0.603-0.534-1.214-1.083-1.823-1.664-12.157-10.285-23.908-7.67-28.781-5.864-1.382 0.554-2.7 1.303-3.629 1.887l-13.086 8.754v12.288l21.888-14.748s10.228-7.589 26.166 0.054l-0.735-0.707m68.722 12.865c-4.563 3.078-9.203 6.203-11.048 7.441-4.128 2.765-13.678 9.614-29.577 2.015l1.869 1.797c0.699 0.63 1.554 1.362 2.481 2.077 11.418 8.53 23.62 7.303 32.769 1.243 1.267-0.838 2.424-1.609 3.507-2.334v-12.234m0-24.61c-10.02 6.738-23.546 15.833-26.085 17.536-4.127 2.765-13.82 9.708-29.379 2.273l1.804 1.729c0.205 0.19 0.409 0.375 0.612 0.571l-0.01 0.01 0.01-0.01c12.079 10.22 25.379 8.657 34.501 2.563 5.146-3.436 12.461-8.38 18.548-12.507l-0.01-12.165m0-24.481c-14.452 9.682-38.162 25.568-41.031 27.493-4.162 2.789-13.974 9.836-29.335 2.5l1.864 1.796c1.111 1.004 2.605 2.259 4.192 3.295 10.632 6.792 21.759 5.591 30.817-0.455 6.512-4.351 22.528-14.998 33.493-22.285v-12.344",
                                        style = "fill:rgb(40%,40%,40%); fill-opacity: 0.2", transform="translate(419,458)scale(0.25)"))
  g_id <- addChildren(g_id, pth_1, pth_2)
  
}

createSVG <- function(time_st){
  
  
  source('surface_init.R')
  source('add_legend.R')
  source('drought_UTM.R')
  source('get_CA_paths.R')
  source('get_mark_col.R')
  source('log_transform.R')
  source('add_ticks.R')
  source('dis_points.R')
  points <- dis_points()
  lg_lim <- c(0.003, 5500)
  tcks <- c(1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2, 1e3)
  minor_tcks <- minor_ticks()
  fig_w = '650'
  fig_h = '550'
  l_mar = '50'
  t_mar = '0'
  b_mar = l_mar
  r_mar = '100'
  inset_dim = '210'
  main_dim = '500'
  x_bump = 20 # pixel bump to shift map
  y_crt = c(as.numeric(t_mar)+as.numeric(main_dim), as.numeric(t_mar))
  x_crt = c(as.numeric(l_mar), as.numeric(l_mar)+as.numeric(main_dim))
  tri_pts <- paste0(l_mar,',',
                    as.character(as.numeric(t_mar)+as.numeric(main_dim)),',',
                    as.character(as.numeric(l_mar)+as.numeric(main_dim)),',',
                    t_mar,',',
                    as.character(as.numeric(l_mar)+as.numeric(main_dim)),',',
                    as.character(as.numeric(t_mar)+as.numeric(main_dim)))
  inset_spc = '10' # from edge of main axis
  inset_spc_y = as.character(as.numeric(inset_spc)+as.numeric(t_mar))
  inset_spc_x = as.character(as.numeric(inset_spc)+as.numeric(l_mar))
  def_opacity = "0.3"
  library(XML)

  g_id <- surface_init(fig_w,fig_h, def_opacity)

  root_nd <- xmlRoot(g_id)
  rect_1 <- newXMLNode("rect",parent=g_id, attrs = c(id="box1", x=l_mar, y=t_mar, 
                        width=main_dim, height=main_dim, 
                        style="fill: rgb(100%,100%,100%);fill-opacity: 1; stroke: none;"))
  rect_2 <- newXMLNode("rect",parent=g_id, attrs = c(id="box2", x=l_mar, y=t_mar, 
                        width=main_dim, height=main_dim, 
                        style="stroke: black; fill: none;"))
  rect_3 <- newXMLNode("rect",parent=g_id, attrs = c(id="box3", x=inset_spc_x, y=inset_spc_y, 
                        width=inset_dim, height=inset_dim, 
                        style="stroke: grey; fill: none; stroke-opacity:0.3;"))
  tri <- newXMLNode("polygon", parent=g_id, attrs = c(points=tri_pts,
                        style="fill:grey;stroke:none;fill-opacity:0.2;"))
  
  addChildren(g_id,c(rect_1,rect_2, rect_3, tri))
  g_id <- add_ticks(g_id, ticks = tcks, y_crt, x_crt, y_lim=lg_lim, x_lim=lg_lim, minor_ticks = minor_tcks)
  
  x_crd <- c(as.numeric(inset_spc_x), as.numeric(inset_spc_x)+as.numeric(inset_dim))
  y_crd <- c(as.numeric(inset_spc_y), as.numeric(inset_spc_y)+as.numeric(inset_dim))
  
  abv_ave <- newXMLNode("text", newXMLTextNode('Above median streamflow'),
                        attrs = c('text-anchor'="left", transform="translate(66,474)rotate(315)"))
  bel_ave <- newXMLNode("text", newXMLTextNode('Below median streamflow'),
                        attrs = c('text-anchor'="left", transform="translate(84,493)rotate(315)"))
  
  g_id <- addChildren(g_id, abv_ave, bel_ave)
  g_id <- add_CA(g_id, points, x_crd+x_bump, y_crd, time_st, def_opacity)
  
  for (i in 1:length(points[[1]])){
    
    nwis_id <- paste0('nwis_',points$id[[i]])
    site_id <- paste0('site_',points$id[[i]])
    site_mo <- paste0('site_',points$id[[i]],'.mouseover')
    site_me <- paste0('site_',points$id[[i]],'.mouseout')
    link_site <- paste0("window.open('http://waterdata.usgs.gov/ca/nwis/uv?site_no=",points$id[[i]],"','_blank')")
    
    cx <- log_tran_x(points$p_50[[i]], 
                     x_crt = x_crt, 
                     x_lim = lg_lim)
    cy <- log_tran_y(points$todayDis[[i]], 
                     y_crt = y_crt, 
                     y_lim = lg_lim)
    if (!is.infinite(cy)){
      mouse_move_txt <- paste0("ShowTooltip(evt, '", points$text[[i]], "')")
      pnt <- newXMLNode("circle", parent=g_id, attrs = c(id = nwis_id, cx=cx, 
                                                         cy=cy,
                                                         r=points$r[[i]], fill="#4169E1", 
                                                         stroke="#4169E1", "stroke-width"="1.5",
                                                         "stroke-opacity"="1",
                                                         "fill-opacity"=def_opacity,
                                                         onmouseover=paste0("MakeOpaque(evt); document.getElementById('",site_id,"').setAttribute('r', '8');document.getElementById('",site_id,"').setAttribute('fill-opacity', '1')"),
                                                         onmousemove=mouse_move_txt,
                                                         onclick=link_site,
                                                         onmouseout=paste0("MakeTransparent(evt); HideTooltip(evt);document.getElementById('",site_id,"').setAttribute('r', '3')")))
      setter <- newXMLNode('set', attrs = c(
        attributeName="fill-opacity", to="1", 
        begin=site_mo,  end=site_me))
      pnt <- addChildren(pnt, c(setter))
      
      addChildren(g_id,pnt)
    }

  }
  
  g_id <- add_usgs(g_id)
  

  tt <- newXMLNode("text", newXMLTextNode('Tooltip'), parent = root_nd, 
                   attrs = c(class="label", id="tooltip", x="0", y="0", 
                             visibility="hidden"))
  
  dt_txt <- paste0(substr(time_st,1,4), '-',substr(time_st,5,6),'-', substr(time_st, 7,8))
  dt <- newXMLNode("text", newXMLTextNode(dt_txt), parent = root_nd, 
                   attrs = c(class="dater", x="285", y="30"))
  doc <- addChildren(root_nd,c(g_id, tt, dt))
  
  
  saveXML(doc, file = '../../Vizzies/public_html/stream-graph.svg')
}