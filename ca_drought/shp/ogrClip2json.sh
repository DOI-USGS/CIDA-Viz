#!/bin/bash

BASENAME=$1
METHOD=$2
TARGETPROJ=$3

if [[ -z "$TARGETPROJ" ]]; then
	TARGETPROJ="EPSG:4326"
fi

if [[ "$METHOD" = "bbox" ]]; then
	echo bboxing
	unzip $BASENAME\_M.zip
	ogr2ogr -f "GeoJSON" $BASENAME.json $BASENAME.shp -clipsrc -124.41 32.18 -113.32 42.97 -t_srs "$TARGETPROJ"
elif [[ "$METHOD" = "shp" ]]; then
	echo shping
	unzip $BASENAME\_M.zip
    ogr2ogr -f "GeoJSON" $BASENAME.json $BASENAME.shp -clipsrc tl_2013_california.shp -t_srs "$TARGETPROJ"
fi

