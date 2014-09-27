var map;
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
	var getFireStyle = function () {
		return [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'red',
					width: 2
				}),
				fill: new ol.style.Fill({
					color: 'red'
				}),
				image: new ol.style.Circle({
					radius: 10,
					fill: null,
					stroke: new ol.style.Stroke({
						color: 'red'
					})
				})
			})];
	};
	var getFireLayer = function (timestep) {
		if (timestep) {
			var layer = new ol.layer.Vector({
				source: new ol.source.GeoJSON({
					url: 'data/fire_shp/FIRE_' + timestep + '.json',
					projection: ol.proj.get('EPSG:3857')
				}),
				style: getFireStyle,
				visible: true,
				opacity: 1
			});
			layer.layer_type = 'fire';
			return layer;
		}

	};

	var getInitialDroughtLayer = function () {
		return getDroughtLayer('20140916_US');
	};

	var getDroughtLayer = function (timestep) {
		if (timestep) {
			var layer = new ol.layer.Vector({
				source: new ol.source.GeoJSON({
					url: 'data/drought_shp/USDM_' + timestep + '.json',
					projection: ol.proj.get('EPSG:3857')
				}),
				style: getDroughtStyle,
				visible: true,
				opacity: 1
			});
			layer.layer_type = 'drought';
			return layer;
		}
	};

	var continentalCenter = ol.proj.transform([-98.5, 39.5], "EPSG:4326", "EPSG:3857");
	var caliCenterCenter = ol.proj.transform([-119.0, 38.0], "EPSG:4326", "EPSG:3857");
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

	var activateAnchorLink = function(linkNum) {
		var filledClass = 'links-anchor-link-filled',
			emptyClass = 'links-anchor-link-empty';
		console.log(linkNum);
		$('.links-anchor').switchClass(filledClass, emptyClass, 250, 'linear', null),
		$('#links-anchor-link-' + linkNum).switchClass(emptyClass, filledClass, 250, 'linear', null);
	};

	var controller = new ScrollMagic();
	// build scenes
	new ScrollScene({triggerElement: "#startTrigger", duration: $(window).height()})
		.on("enter", function (e) {
			$("#time-indicator").text("");
			//panAndZoom(continentalCenter, continentalZoom);
			map.replaceLayer(getInitialDroughtLayer(), 'drought');
			activateAnchorLink(1);
		})
		.addTo(controller)
		.addIndicators();
	// Scene 1 built in response to ajax
	new ScrollScene({triggerElement: "#trigger2", duration: 2000})
		.setPin("#feature2")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
			activateAnchorLink(2);
		})
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#trigger3", duration: 2000})
		.setPin("#feature3")
		.on("enter", function (e) {
			panAndZoom(caliRightCenter, caliZoom);
			activateAnchorLink(3);
		})
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#trigger4", duration: 5000})
		.setPin("#feature4")
		.on("enter", function (e) {
			panAndZoom(caliLeftCenter, caliZoom);
			activateAnchorLink(4);
		})
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#trigger5", duration: 2000})
		.setPin("#feature5")
		.on("enter", function (e) {
			panAndZoom(caliRightCenter, caliZoom);
			activateAnchorLink(5);
		})
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#news-trigger", duration: 1000})
		.setPin("#news")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#tahoe-trigger", duration: 1000})
		.setPin("#tahoe")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#drilling-trigger", duration: 1000})
		.setPin("#drilling")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#parched-trigger", duration: 1000})
		.setPin("#parched")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#brink-trigger", duration: 1000})
		.setPin("#brink")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#toll-trigger", duration: 1000})
		.setPin("#toll")
		.addTo(controller)
		.addIndicators();
	new ScrollScene({triggerElement: "#burning-trigger", duration: 1000})
		.setPin("#burning")
		.addTo(controller)
		.addIndicators()
		.on("enter", function (e) {
			activateAnchorLink(6);
		});

	map.replaceLayer = function (layer, layerType) {
		if (layer) {
			map.addLayer(layer);
			layer.getSource().on('change', function (event) {
				var isReady = event.target.state_ === 'ready';
				if (isReady) {
					var layers = map.getLayers().array_.filter(function (oldLayer) {
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
			});
		}
	};

	var updateTimestep = function (timestep) {
		var droughtLayer = getDroughtLayer(timestep);
		var fireLayer = getFireLayer(timestep);
		var datestr = Date.create(timestep).format("{d} {Month} {yyyy}");
		map.replaceLayer(droughtLayer, 'drought');
		map.replaceLayer(fireLayer, 'fire');
		$('#time-indicator').text(datestr);
	};
	var sitesLayer = new ol.layer.Vector({
		source: new ol.source.GeoJSON({
			url: 'data/reservoirs/ca_reservoirs.geojson',
			projection: ol.proj.get('EPSG:3857')
		}),
		style: [new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'blue',
					width: 2
				}),
				fill: new ol.style.Fill({
					color: 'blue'
				}),
				image: new ol.style.Circle({
					radius: 1,
					fill: null,
					stroke: new ol.style.Stroke({
						color: 'blue'
					})
				})
			})],
		visible: true,
		opacity: 1
	});
	map.addLayer(sitesLayer);

	var lastIndexCalled = -1;
	$.ajax('data/drought_shp/times.json', {
		success: function (data) {
			var timesArray = data.d.reverse();
			new ScrollScene({triggerElement: "#trigger1", duration: 40000})
				.setPin("#feature1")
				.setTween(TweenMax.fromTo("#time-indicator", 1, {x: 0}, {x: $(window).width() - 400}))
				.on("progress", function (e) {
					var index = Math.floor((timesArray.length - 1) * e.progress);
					if (index != lastIndexCalled) {
						updateTimestep(timesArray[index]);
						lastIndexCalled = index;
					}
				})
				.on("enter", function (e) {
					panAndZoom(caliCenterCenter, caliZoom);
				})
				.addTo(controller)
				.addIndicators();
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

	smoothScroll.init({
		speed: 1000,
		easing: 'easeInOutCubic',
		offset: 0,
		updateURL: true,
		callbackBefore: function (t, a) {
		},
		callbackAfter: function (t, a) {
		}
	});

	new ScrollControl({
		scrollRate: 50,
		scrollStep: 40, 
		parent: $(document.body)
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
        y : 21.25
      } , 
      { 
        key: "Domestic",
        y : 1.48
      } , 
      { 
        key: "Irrigation",
        y : 74.18
      } , 
      { 
        key: "Livestock",
        y : 0.6
      } , 
      { 
        key: "Aquaculture",
        y : 1.96
      } , 
      { 
        key: "Industrial",
        y : 0.22
      } , 
      { 
        key: "Mining",
        y : 0.16
      } , 
      { 
        key: "Thermoelectric",
        y : 0.15
      }
  ];


	nv.addGraph(function() {
		var width = 500,
			height = 500;

		var chart = nv.models.pieChart()
			.x(function(d) { return d.key })
			.y(function(d) { return d.y })
			.color(d3.scale.category10().range())
			.width(width)
			.height(height);

		  d3.select("#usage")
			  .datum(ca_consume)
			.transition().duration(1200)
			  .attr('width', width)
			  .attr('height', height)
			  .call(chart);

		chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });

		return chart;
	});

});
