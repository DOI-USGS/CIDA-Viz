var map;
var timesteps = ["20150310","20150303","20150224","20150217","20150210","20150203","20150127","20150120","20150113", "20150106", "20141230", "20141223", "20141216", "20141209", "20141202", "20141125", "20141118", "20141111", "20141104", "20141028", "20141021", "20141014", "20141007", "20140930", "20140923","20140916", "20140909", "20140902", "20140826", "20140819", "20140812", "20140805", "20140729", "20140722", "20140715", "20140708", "20140701", "20140624", "20140617", "20140610", "20140603", "20140527", "20140520", "20140513", "20140506", "20140429", "20140422", "20140415", "20140408", "20140401", "20140325", "20140318", "20140311", "20140304", "20140225", "20140218", "20140211", "20140204", "20140128", "20140121", "20140114", "20140107", "20131231", "20131224", "20131217", "20131210", "20131203", "20131126", "20131119", "20131112", "20131105", "20131029", "20131022", "20131015", "20131008", "20131001", "20130924", "20130917", "20130910", "20130903", "20130827", "20130820", "20130813", "20130806", "20130730", "20130723", "20130716", "20130709", "20130702", "20130625", "20130618", "20130611", "20130604", "20130528", "20130521", "20130514", "20130507", "20130430", "20130423", "20130416", "20130409", "20130402", "20130326", "20130319", "20130312", "20130305", "20130226", "20130219", "20130212", "20130205", "20130129", "20130122", "20130115", "20130108", "20130101", "20121225", "20121218", "20121211", "20121204", "20121127", "20121120", "20121113", "20121106", "20121030", "20121023", "20121016", "20121009", "20121002", "20120925", "20120918", "20120911", "20120904", "20120828", "20120821", "20120814", "20120807", "20120731", "20120724", "20120717", "20120710", "20120703", "20120626", "20120619", "20120612", "20120605", "20120529", "20120522", "20120515", "20120508", "20120501", "20120424", "20120417", "20120410", "20120403", "20120327", "20120320", "20120313", "20120306", "20120228", "20120221", "20120214", "20120207", "20120131", "20120124", "20120117", "20120110", "20120103", "20111227", "20111220", "20111213", "20111206", "20111129", "20111122", "20111115", "20111108", "20111101", "20111025", "20111018", "20111011", "20111004", "20110927", "20110920", "20110913", "20110906", "20110830", "20110823", "20110816", "20110809", "20110802", "20110726", "20110719", "20110712", "20110705", "20110628", "20110621", "20110614", "20110607", "20110531", "20110524", "20110517", "20110510", "20110503", "20110426", "20110419", "20110412", "20110405", "20110329", "20110322", "20110315", "20110308", "20110301", "20110222", "20110215", "20110208", "20110201", "20110125", "20110118", "20110111", "20110104"];
var droughtCache = {};
$(document).ready(function () {

	var getDroughtStyle = function (feature) {
		var dm = feature.values_.DM,
			fillColors = {
				0: 'rgba(255, 255, 0, 0.5)',
				1: 'rgba(255, 211, 127, 0.5)',
				2: 'rgba(230, 152, 0, 0.5)',
				3: 'rgba(230, 0, 0, 0.5)',
				4: 'rgba(115, 0, 0, 0.5)'
			};
		return [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: fillColors[dm],
					width: 1
				}),
				fill: new ol.style.Fill({
					color: fillColors[dm]
				})
			})];
	};

	var getInitialDroughtLayer = function () {
		return getDroughtLayer('20140916_US');
	};

	var getDroughtLayer = function (timestep) {
		if (timestep) {
			var geoJSON,
				cachedTimestep = droughtCache[timestep],
				projection = ol.proj.get('EPSG:3857');
			if (cachedTimestep) {
				geoJSON = new ol.source.GeoJSON({
					text: Object.clone(cachedTimestep, true),
					projection: projection
				});
			} else {
				geoJSON = new ol.source.GeoJSON({
					url: 'data/drought_shp/USDM_' + timestep + '.json',
					projection: projection
				});
			}
			var layer = new ol.layer.Vector({
				source: geoJSON,
				style: getDroughtStyle,
				visible: true,
				opacity: 1,
				name : timestep
			});
			layer.layer_type = 'drought';
			layer.name = timestep;
			return layer;
		}
	};

	var reservoirSizes = [];
	var getReservoirLayer = function (timestep) {
		if (timestep) {
			var getReservoirStyle = function (feature) {
				var id = feature.getProperties()['Nat_ID'];
				var matchingRes = reservoirSizes.find(function (res) {
					return res['Nat_ID'] === id;
				});
				var radius = 0;
				if (matchingRes) {
					var storage = matchingRes.Storage[timestep];
					var a = 1000;
					radius = Math.sqrt(storage/(a*Math.PI));
					radius = (radius > 0 || radius < 1) ? radius : 1;
				}
				return [new ol.style.Style({
					image: new ol.style.Circle({
						radius: radius,
						fill: new ol.style.Fill({
							color: 'rgba(0, 0, 255, 0.2)'
						}),
						stroke: new ol.style.Stroke({
							color: 'blue',
							width: 1.5
						})
					})
				})];
			};

			var layer = new ol.layer.Vector({
				source: new ol.source.GeoJSON({
					url: 'data/reservoirs/ca_reservoirs.geojson',
					projection: ol.proj.get('EPSG:3857')
				}),
				style: getReservoirStyle,
				visible: true,
				opacity: 1
			});
			layer.layer_type = 'reservoir';
			return layer;
		}
	};

	var continentalCenter = ol.proj.transform([-98.5, 39.5], "EPSG:4326", "EPSG:3857");
	var caliCenterCenter = ol.proj.transform([-115.5, 38.0], "EPSG:4326", "EPSG:3857");
	var caliLeftCenter = ol.proj.transform([-110.0, 38.0], "EPSG:4326", "EPSG:3857");
	var caliRightCenter = ol.proj.transform([-128.0, 38.0], "EPSG:4326", "EPSG:3857");

	var continentalZoom = 4;
	var caliZoom = 6;

	var view = new ol.View({
		center: continentalCenter,
		zoom: continentalZoom
	});

	map = new ol.Map({
		layers: [
			new ol.layer.Tile({
				source: new ol.source.OSM()
			})
		],
		target: 'map',
		controls: [new ol.control.MousePosition()],
		view: view,
		renderer: 'canvas'
	});
	var panAndZoom = function (center, zoomLevel) {
		var duration = 1500;
		var start = +new Date();
		var pan = ol.animation.pan({
			duration: duration,
			source: map.getView().getCenter()
		});
		var zoom = ol.animation.zoom({
			duration: duration,
			resolution: map.getView().getResolution()
		});
		map.beforeRender(pan, zoom);
		map.getView().setCenter(center);
		map.getView().setZoom(zoomLevel);
	};

	var activateAnchorLink = function (linkNum) {
		var filledClass = 'links-anchor-link-filled',
			emptyClass = 'links-anchor-link-empty';
		$('.links-anchor').switchClass(filledClass, emptyClass, 250, 'linear', null),
			$('#links-anchor-link-' + linkNum).switchClass(emptyClass, filledClass, 250, 'linear', null);
	};

	var controller = new ScrollMagic();
	// build scenes
	new ScrollScene({triggerElement: "#start-trigger", duration: $(window).height()})
		.on("enter", function (e) {
			panAndZoom(continentalCenter, continentalZoom);
			map.replaceLayer(getInitialDroughtLayer(), 'drought');
			activateAnchorLink(1);
		})
		.addTo(controller);
	new ScrollScene({triggerElement: "#tahoe-trigger", duration: 500})
		.setPin("#tahoe-pin")
		.addTo(controller);
	new ScrollScene({triggerElement: "#drilling-trigger", duration: 500})
		.setPin("#drilling-pin")
		.addTo(controller);
	new ScrollScene({triggerElement: "#google-trigger", duration: 500})
		.setPin("#google-pin")
	// Scene 1 (reservoirs) built in response to ajax
	new ScrollScene({triggerElement: "#landsat-trigger", duration: 500})
		.setPin("#landsat-pin")
		.on("enter", function (e) {
			panAndZoom(caliRightCenter, caliZoom);
			activateAnchorLink(4);
		})
		.addTo(controller);
	new ScrollScene({triggerElement: "#snowpack-trigger", duration: 500})
		.setPin("#snowpack-pin")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
			activateAnchorLink(5);
		})
		.addTo(controller);
	new ScrollScene({triggerElement: "#snowpack-plot-trigger", duration: 500})
		.setPin("#snowpack-plot-pin")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
		})
		.addTo(controller);
	new ScrollScene({triggerElement: "#streams-trigger", duration: 500})
		.setPin("#streams-pin")
		.addTo(controller);
	new ScrollScene({triggerElement: "#sidebar-trigger", duration: 500})
		.setPin("#sidebar-pin")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
		})
		.addTo(controller);
	new ScrollScene({triggerElement: "#usage-pie-trigger", duration: 500})
		.setPin("#usage-pie-pin")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
		})
		.addTo(controller);
	// new ScrollScene({triggerElement: "#food-trigger", duration: 500})
	// 	.setPin("#food-pin")
	// 	.on("enter", function (e) {
	// 		panAndZoom(caliCenterCenter, caliZoom);
	// 		activateAnchorLink(6);
	// 	})
	// 	.addTo(controller);
	new ScrollScene({triggerElement: "#credits-trigger", duration: $(window).height()})
		.on("enter", function (e) {
			panAndZoom(continentalCenter, continentalZoom);
			map.replaceLayer(getInitialDroughtLayer(), 'drought');
			activateAnchorLink(7);
		})
		.addTo(controller);

	map.replaceLayer = function (layer, layerType) {
		if (layer) {
			var replaceLayerOnChange = function (event) {
				var isReady = event.target.state_ === 'ready';
				if (isReady) {
					var layers = map.getLayers().getArray().findIndex(function (oldLayer) {
						if (oldLayer) {
							return oldLayer.layer_type === layerType && oldLayer !== layer;
						} else {
							return false;
						}

					});

					
					var layers = map.getLayers().getArray().filter(function (oldLayer) {
						if (oldLayer) {
							return oldLayer.layer_type === layerType && oldLayer !== layer;
						} else {
							return false;
						}

					});

					for (var i = 0; i < layers.length; i++) {
						map.removeLayer(layers[i]);
					}
				}
			}
			
			layer.getSource().on('change', replaceLayerOnChange);
			
			map.addLayer(layer);
			
			if (layer.getSource().getState() === 'ready') {
				layer.getSource().dispatchChangeEvent();
			}
		}
	};
	
	map.removeLayerOfType = function(layerType) {
		if (layerType) {
			var layers = map.getLayers().getArray().filter(function (oldLayer) {
				if (oldLayer) {
					return oldLayer.layer_type === layerType;
				} else {
					return false;
				}
			});

			for (var i = 0; i < layers.length; i++) {
				map.removeLayer(layers[i]);
			}
		}
	};

	var updateTimestep = function (timestep) {
		var droughtLayer = getDroughtLayer(timestep);
		var reservoirLayer = getReservoirLayer(timestep);
		var datestr = Date.create(timestep).format("{d} {Month} {yyyy}");
		map.replaceLayer(droughtLayer, 'drought');
		map.replaceLayer(reservoirLayer, 'reservoir');
		$('#time-indicator').text(datestr);
	};

	var cacheDroughtLayers = function (args) {
		var args = args || {},
			timesArray = args.timesArray || [],
			nextTimeStep = timesArray.pop(),
			context = {
				timesArray: timesArray,
				timestep: nextTimeStep
			};

		if (nextTimeStep) {
			$.ajax('data/drought_shp/USDM_' + nextTimeStep + '.json',
				{
					context: context,
					headers : {
						Accept : 'application/json'
					},
					success: function (data) {
						droughtCache[this.timestep] = data;
						if (timesArray.length) {
							cacheDroughtLayers({
								timesArray: timesArray
							});
						}
					},
					error: function (data) {
						if (timesArray.length) {
							cacheDroughtLayers({
								timesArray: timesArray
							});
						}
					}
				});
		}
	};

	var lastIndexCalled = -1;
	var timesArray = timesteps.reverse();
	new ScrollScene({triggerElement: "#reservoir-trigger", duration: 10000})
		.setPin("#reservoir-pin")
		.on("progress", function (e) {
			var index = Math.floor((timesArray.length - 1) * e.progress);
			if (index !== lastIndexCalled) {
				updateTimestep(timesArray[index]);
				reservoirPlot.paintGraph(reservoirPlot.getDataAtTimestep(undefined, timesArray[index]));
				lastIndexCalled = index;
			}
		})
		.on("enter", function (e) {
			panAndZoom(caliCenterCenter, caliZoom);
			$("#res-plot-container").show();
			$("#time-indicator").show();
			activateAnchorLink(3);
		})
		.on("leave", function (e) {
			$("#res-plot-container").hide();
			$("#time-indicator").hide();
			map.removeLayerOfType("reservoir");
		})
		.addTo(controller);

	// Begin caching drought layers
	cacheDroughtLayers({
		timesArray: timesArray.clone()
	});

	$.ajax("data/reservoirs/reservoir_storage.json", {
		success: function (data) {
			// apologies for using global scope
			reservoirSizes = data;
		}
	});

	$('.links-anchor').on('click', function (e) {
		var $target = $(e.target),
			filledClass = 'links-anchor-link-filled',
			emptyClass = 'links-anchor-link-empty';

		if ($target.hasClass(filledClass)) {
			e.stopImmediatePropagation();
			return false;
		} else {
			$('.' + filledClass).switchClass(filledClass, emptyClass, 250, 'linear', function () {
			});
			$target.switchClass(emptyClass, filledClass, 250, 'linear', function () {
			});
		}
	});

	$(document).tooltip({
		position: {
			my: "right-20",
			at: "center left"
		}
	});

	var ca_consume = [
		{
			key: "Public supply",
			y: 16.6
		},
		{
			key: "Domestic",
			y: 0.5
		},
		{
			key: "Irrigation",
			y: 60.7
		},
		{
			key: "Livestock",
			y: 0.5
		},
		{
			key: "Aquaculture",
			y: 2.6
		},
		{
			key: "Industrial",
			y: 1.0
		},
		{
			key: "Mining",
			y: 0.7
		},
		{
			key: "Thermoelectric",
			y: 17.4
		}
	];


	nv.addGraph(function () {
		var width = 500,
			height = 500;

		var chart = nv.models.pieChart()
			.x(function (d) {
				return d.key
			})
			.y(function (d) {
				return d.y
			})
			.color(d3.scale.category10().range())
			.width(width)
			.height(height);

		d3.select("#usage")
			.datum(ca_consume)
			.transition().duration(1200)
			.attr('width', width)
			.attr('height', height)
			.call(chart);

		chart.dispatch.on('stateChange', function (e) {
			nv.log('New State:', JSON.stringify(e));
		});

		return chart;
	});
});
