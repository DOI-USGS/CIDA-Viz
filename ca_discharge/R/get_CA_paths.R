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