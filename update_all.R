#Overall update

## check that we're in the right place
origin = getwd()
if(basename(origin) != 'CIDA-Viz'){
	stop('Check your locaiton, you should be in base CIDA-Viz path')
}

## Update the drought layer
setwd('ca_drought/R')

## this will probably fail
source('update.R')

setwd(origin)

## Update reservoir data/visualizations
setwd('ca_reservoirs/R')
source('update.R')

setwd(origin)


## Update discharge figure
# need to know last drought layer date
library(jsonlite)
times_json = fromJSON('Vizzies/public_html/data/drought_shp/times.json')

setwd('ca_discharge/R')
source('getRefSites.R')
source('getNWISdata.R')

source('discharge_svg.R')
createSVG(max(times_json$d))
#file.rename(paste0('../Figures/discharge_', max(times_json$d), '.svg'),
#						'../../Vizzies/public_html/stream-graph.svg')

##Manual step, update dates in main.js
setwd(origin) #Done!

