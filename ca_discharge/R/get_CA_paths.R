get_CA_paths <- function(g_id, lyr_info, x_crd, y_crd){
  
  #x_crd is left and right bounds of area (ASSUMING SQUARE)
  #y_crd is top and bottom of bounds
  
  library(XML)
  doc = xmlInternalTreeParse(lyr_info$file_nm)
  xmltop = xmlRoot(doc)
  
  # just a little check...
  if (!all((names(xmlAttrs(xmltop[[1]][[1]])[3:4]) == c('width','height')))){stop('bad data')}
  doc_width <- xmlAttrs(xmltop[[1]][[1]])[[3]]
  doc_height <- xmlAttrs(xmltop[[1]][[1]])[[4]]
  paths <- xmltop[[1]][names((xmltop[[1]])) == 'path']
  for (i in 1:length(paths)){
    paths[[i]] <- addAttributes(paths[[i]], 'transform'="scale(0.75)translate(25,25)")
  }
  g_id <- addChildren(g_id, paths)
  
  return(g_id)
}