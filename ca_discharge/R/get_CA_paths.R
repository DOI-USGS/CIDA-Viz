get_CA_paths <- function(g_id, lyr_info, x_crd, y_crd){
  
  #x_crd is left and right bounds of area (ASSUMING SQUARE)
  #y_crd is top and bottom of bounds
  
  library(XML)
  doc = xmlInternalTreeParse(lyr_info$file_nm)
  xmltop = xmlRoot(doc)
  
  # just a little check...
  if (!all((names(xmlAttrs(xmltop[[1]][[1]])[3:4]) == c('width','height')))){stop('bad data')}
  doc_width <- as.numeric(xmlAttrs(xmltop[[1]][[1]])[[3]])
  doc_height <- as.numeric(xmlAttrs(xmltop[[1]][[1]])[[4]])
  
  scale_f <- diff(x_crd)/doc_width #(ASSUMING SQUARE)!!!
  trn_x <- x_crd[1]/scale_f
  trn_y <- y_crd[1]/scale_f
  
  
  
  paths <- xmltop[[1]][names((xmltop[[1]])) == 'path']
  for (i in 1:length(paths)){
    paths[[i]] <- addAttributes(paths[[i]], 'transform'=paste0(
      "scale(",as.character(scale_f) ,")translate(",as.character(trn_x),",",as.character(trn_y),")"))
  }
  g_id <- addChildren(g_id, paths)
  
  return(g_id)
}

WGS84_to_svg <- function(WGS_pnt, lyr_info){
  init_coord <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  
  WGS_mat <- matrix(WGS_pnt,ncol=2)
  pnt <- SpatialPoints(coords = WGS_mat, proj4string = CRS(init_coord))
  
  pnt_UTM <- spTransform(pnt,CRS(lyr_info$coord_ref))
  
  point <- c(as.numeric(pnt_UTM$coords.x1), as.numeric(pnt_UTM$coords.x2)) # x, y
  rect <- max(c(diff(lyr_info$xlim), diff(lyr_info$ylim)))
  rel_point <- c(point[1]- lyr_info$xlim[1], lyr_info$ylim[2]-point[2])/rect # relative from upper left
  
  
  return(rel_point)
}

box_pnts <- function(rel_pnt, x_crd, y_crd){
  #relative is relative to upper left
  
  box_w <- diff(x_crd)
  pnts <- rel_pnt*box_w
  x <- x_crd[1]+pnts[1]
  y <- y_crd[1]+pnts[2]
  return(c(x,y))
}