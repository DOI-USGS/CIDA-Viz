 ###California Reservoir Data sources and processing methods
 
 Reservoir time series data was processed using the following workflow:
 
 The initial set of reservoirs to focus was chosen based on which reservoirs had daily storage values from the [California Data Exchange Center Query Tools](http://cdec.water.ca.gov/cgi-progs/queryDaily). 

Initial reservoir metadata were copied from the [California Data Exchange Center Daily reservoir data summary page](http://cdec.water.ca.gov/misc/daily_res.html), and supplemented with reservoir storage capacity, year built, and national ID data from the California Department of Water Resources for [reservoirs under federal jurisdiction(pdf)](http://www.water.ca.gov/damsafety/docs/Federal2010.pdf) and [under state jurisdiction(pdf)](http://www.water.ca.gov/damsafety/docs/Jurisdictional2014.pdf).  These data then used to hand write a [base reservoir metadata file in json format](./Data/ca_reservoirs.json)
 
The daily storage values from 2000-present for these 83 reservoirs were scraped using [get_cal_reservoir_storage.R](./R/get_cal_reservoir_storage.R).  CSVs of data for each reservoir based on these data pulls were placed in the [storage_data folder](storage_data/).  The commit date and time for these CSVs is within a few minutes of the date and time that the CSVs were pulled.  Initial plots of storage values based on this raw data were generated and are available in the [storage_plots folder](storage_plots).

Final time series for daily storage data were generated using the [build_res_json](./R/build_res_json.R) R script. build\_res\_json
1. removes errent data using the [sensorQC library](https://github.com/USGS-R/sensorQC)
2. interpolates small gaps in the data based on preceeding and following data
3. drops reservoirs that have large gaps in daily data
4. downsample to weekly values from daily using an average of daily values
5. generates a [final JSON data file](../Vizzies/public_html/data/reservoirs/reservoir_storage.json)

As a final data quality check, maximum qc'ed daily values were plotted against the reservoir capacities recorded in the dam metadata to make sure the data were reasonably close, considering the inexact nature of reservoir storage numbers, using [cross_check_capacity](./R/cross_check_capacity.R) 

[build_res_json](.R/build_res_json) was used to generate a [GeoJSON file](../Vizzies/public_html/data/reservoirs/ca_reservoirs.geojson) for mapping reservoir locations was built based on metadata in the [final JSON data file](../Vizzies/public_html/data/reservoirs/reservoir_storage.json).



 
