var map;
$(document).ready(function () {

	var image = new ol.style.Circle({
		radius: 5,
		fill: null,
		stroke: new ol.style.Stroke({color: 'red', width: 1})
	});

	var styles = {
		'Point': [new ol.style.Style({
				image: image
			})],
		'LineString': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'green',
					width: 1
				})
			})],
		'MultiLineString': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'green',
					width: 1
				})
			})],
		'MultiPoint': [new ol.style.Style({
				image: image
			})],
		'MultiPolygon': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'yellow',
					width: 1
				}),
				fill: new ol.style.Fill({
					color: 'rgba(255, 255, 0, 0.1)'
				})
			})],
		'Polygon': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'blue',
					lineDash: [4],
					width: 3
				}),
				fill: new ol.style.Fill({
					color: 'rgba(0, 0, 255, 0.1)'
				})
			})],
		'GeometryCollection': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'magenta',
					width: 2
				}),
				fill: new ol.style.Fill({
					color: 'magenta'
				}),
				image: new ol.style.Circle({
					radius: 10,
					fill: null,
					stroke: new ol.style.Stroke({
						color: 'magenta'
					})
				})
			})],
		'Circle': [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'red',
					width: 2
				}),
				fill: new ol.style.Fill({
					color: 'rgba(255,0,0,0.2)'
				})
			})]
	};

	var styleFunction = function (feature, resolution) {
		return styles[feature.getGeometry().getType()];
	};

	var vectorSource1 = new ol.source.GeoJSON(({
		object: {
			'type': 'FeatureCollection',
			'crs': {
				'type': 'name',
				'properties': {
					'name': 'EPSG:3857'
				}
			},
			'features': [
				{
					'type': 'Feature',
					'geometry': {
						'type': 'Point',
						'coordinates': [0, 0]
					}
				},
				{
					'type': 'Feature',
					'geometry': {
						'type': 'LineString',
						'coordinates': [[4e6, -2e6], [8e6, 2e6]]
					}
				},
				{
					'type': 'Feature',
					'geometry': {
						'type': 'LineString',
						'coordinates': [[4e6, 2e6], [8e6, -2e6]]
					}
				}
			]
		}
	}));

	var vectorSource2 = new ol.source.GeoJSON(({
		object: {
			'type': 'FeatureCollection',
			'crs': {
				'type': 'name',
				'properties': {
					'name': 'EPSG:3857'
				}
			},
			'features': [
				{
					'type': 'Feature',
					'geometry': {
						'type': 'MultiLineString',
						'coordinates': [
							[[-1e6, -7.5e5], [-1e6, 7.5e5]],
							[[1e6, -7.5e5], [1e6, 7.5e5]],
							[[-7.5e5, -1e6], [7.5e5, -1e6]],
							[[-7.5e5, 1e6], [7.5e5, 1e6]]
						]
					}
				}
			]
		}
	}));

	var vectorSource3 = new ol.source.GeoJSON(({
		object: {
			'type': 'FeatureCollection',
			'crs': {
				'type': 'name',
				'properties': {
					'name': 'EPSG:3857'
				}
			},
			'features': [
				{
					'type': 'Feature',
					'geometry': {
						'type': 'MultiPolygon',
						'coordinates': [
							[[[-5e6, 6e6], [-5e6, 8e6], [-3e6, 8e6], [-3e6, 6e6]]],
							[[[-2e6, 6e6], [-2e6, 8e6], [0, 8e6], [0, 6e6]]],
							[[[1e6, 6e6], [1e6, 8e6], [3e6, 8e6], [3e6, 6e6]]]
						]
					}
				}
			]
		}
	}));

	var vectorSource4 = new ol.source.GeoJSON(({
		object: {
			'type': 'FeatureCollection',
			'crs': {
				'type': 'name',
				'properties': {
					'name': 'EPSG:3857'
				}
			},
			'features': [
				{
					'type': 'Feature',
					'geometry': {
						'type': 'GeometryCollection',
						'geometries': [
							{
								'type': 'LineString',
								'coordinates': [[-5e6, -5e6], [0, -5e6]]
							},
							{
								'type': 'Point',
								'coordinates': [4e6, -5e6]
							},
							{
								'type': 'Polygon',
								'coordinates': [[[1e6, -6e6], [2e6, -4e6], [3e6, -6e6]]]
							}
						]
					}
				}
			]
		}
	}));

	var geoJSONLayer = new ol.layer.Vector({
		source: new ol.source.GeoJSON({
			url: 'data/drought_shp/USDM_20140916.json',
			projection: ol.proj.get('EPSG:4326')
		}),
		style: new ol.style.Style({
			stroke: new ol.style.Stroke({
				color: 'blue',
				lineDash: [4],
				width: 3
			}),
			fill: new ol.style.Fill({
				color: 'rgba(0, 0, 255, 0.1)'
			})
		}),
		visible: true,
		opacity: 1
	});

	var vectorLayer1 = new ol.layer.Vector({
		source: vectorSource1,
		opacity: 0,
		style: styleFunction
	});
	var vectorLayer2 = new ol.layer.Vector({
		source: vectorSource2,
		opacity: 0,
		style: styleFunction
	});
	var vectorLayer3 = new ol.layer.Vector({
		source: vectorSource3,
		opacity: 0,
		style: styleFunction
	});
	var vectorLayer4 = new ol.layer.Vector({
		source: vectorSource4,
		opacity: 0,
		style: styleFunction
	});

	var view = new ol.View({
		center: [0, 0],
		zoom: 2
	});

	map = new ol.Map({
		layers: [
			new ol.layer.Tile({
				source: new ol.source.OSM()
			}),
			geoJSONLayer,
			vectorLayer1,
			vectorLayer2,
			vectorLayer3,
			vectorLayer4
		],
		target: 'map',
		controls: [new ol.control.MousePosition()],
		view: new ol.View({
			center: [-13319610.800861657, 4501835.217883743],
			zoom: 5
		}),
		renderer: 'canvas'
	});

	var flyToFeatureExtent = function (source) {
		var duration = 2000;
		var start = +new Date();
		var pan = ol.animation.pan({
			duration: duration,
			source: /** @type {ol.Coordinate} */ (view.getCenter()),
			start: start
		});
		var bounce = ol.animation.bounce({
			duration: duration,
			resolution: 4 * view.getResolution(),
			start: start
		});
		map.beforeRender(pan, bounce);
		view.setCenter(ol.extent.getCenter(source.getExtent()));
	};

	// define params
	var duration = 500;
	var bgPosMovement = "0 " + (duration * 0.8) + "px";

	// init controller
	var controller = new ScrollMagic({globalSceneOptions: {triggerHook: "onEnter", duration: duration}});

	// build scenes
	new ScrollScene({triggerElement: "#feature1"})
		.setTween(TweenMax.to("#feature1", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter start", function (e) {
			flyToFeatureExtent(vectorSource1);
			vectorLayer1.setOpacity(1);
		})
		.on("leave", function (e) {
			vectorLayer1.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature2"})
		.setTween(TweenMax.to("#feature2", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(vectorSource2);
			vectorLayer2.setOpacity(1);
		})
		.on("leave", function (e) {
			vectorLayer2.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature3"})
		.setTween(TweenMax.to("#feature3", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(vectorSource3);
			vectorLayer3.setOpacity(1);
		})
		.on("leave", function (e) {
			vectorLayer3.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature4"})
		.setTween(TweenMax.to("#feature4", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(vectorSource4);
			vectorLayer4.setOpacity(1);
		})
		.on("leave", function (e) {
			vectorLayer4.setOpacity(0);
		});
		
		new ScrollScene({triggerElement: "#feature5"})
		.setTween(TweenMax.to("#feature5", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(vectorSource5);
			vectorLayer5.setOpacity(1);
		})
		.on("leave", function (e) {
			vectorLayer5.setOpacity(0);
		});
		
});