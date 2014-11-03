surface_init <- function(fig_w,fig_h, def_opacity){
  library(XML)
  doc <- xmlParse(paste0('<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" onload="init(evt)" width="',
  fig_w,'" height="',fig_h,'">
                         <style>
                         
                         text{
                         font-size: 16px;
                         cursor: default;
                         font-family: Tahoma, Geneva, sans-serif;
                         }
                         .tooltip{
                         font-size: 12px;
                         }
                         .caption{
                         font-size: 12px;
                         font-family: Tahoma, Geneva, sans-serif;
                         }
                         </style>
                         
                         <script type="text/ecmascript">
                         <![CDATA[
                         
                         function init(evt)
{
                         if ( window.svgDocument == null )
{
                         svgDocument = evt.target.ownerDocument;
}
                         
                         tooltip = svgDocument.getElementById("tooltip");
}
                         
                         function ShowTooltip(evt, mouseovertext)
{
                         tooltip.setAttributeNS(null,"x",evt.clientX+8);
                         tooltip.setAttributeNS(null,"y",evt.clientY+4);
                         tooltip.firstChild.data = mouseovertext;
                         tooltip.setAttributeNS(null,"visibility","visible");
}
                         
                         function HideTooltip(evt)
{
                         tooltip.setAttributeNS(null,"visibility","hidden");
}
                         function MakeTransparent(evt) {
                         evt.target.setAttributeNS(null,"fill-opacity","', def_opacity,'");
                         }
                         
                         function MakeOpaque(evt) {
                         evt.target.setAttributeNS(null,"fill-opacity","1");
                         }
                         
                         ]]>
                         </script></svg>'))
  
  root_nd <- xmlRoot(doc)
  
  g_id <- newXMLNode("g",parent=root_nd, attrs = c(id="surface0"))

  
  return(g_id)
}