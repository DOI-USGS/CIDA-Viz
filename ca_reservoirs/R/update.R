## Update all stuff in order
# scrape the new data
source('get_cal_reservoir_storage.R')

# build the new json file.
source('build_res_json.R')

#not pre-generating the plots anymore
# update the generated figures
#source('plot_res_map.R')

