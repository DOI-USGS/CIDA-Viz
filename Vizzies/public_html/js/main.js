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

	var geoJSONLayer = new ol.layer.Vector({
		source: new ol.source.GeoJSON({
			url: 'data/drought_shp/USDM_20140916.json',
			projection: ol.proj.get('EPSG:3857')
		}),
		style: getDroughtStyle,
		visible: true,
		opacity: 1
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
			geoJSONLayer
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
			source: /** @type {ol.Coordinate} */ (map.getView().getCenter()),
			start: start
		});
		var bounce = ol.animation.bounce({
			duration: duration,
			resolution: 4 * map.getView().getResolution(),
			start: start
		});
		map.beforeRender(pan, bounce);
		if (map && ol.extent && source && source.getState() !== 'loading') {
			map.getView().setCenter(ol.extent.getCenter(source.getExtent()));
		}
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
			flyToFeatureExtent(geoJSONLayer.getSource());
			// vectorLayer1.setOpacity(1);
		})
		.on("leave", function (e) {
			// vectorLayer1.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature2"})
		.setTween(TweenMax.to("#feature2", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(geoJSONLayer.getSource());
			// vectorLayer2.setOpacity(1);
		})
		.on("leave", function (e) {
			// vectorLayer2.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature3"})
		.setTween(TweenMax.to("#feature3", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(geoJSONLayer.getSource());
			// vectorLayer3.setOpacity(1);
		})
		.on("leave", function (e) {
			// vectorLayer3.setOpacity(0);
		});

	new ScrollScene({triggerElement: "#feature4"})
		.setTween(TweenMax.to("#feature4", 1, {backgroundPosition: bgPosMovement, ease: Linear.easeNone}))
		.addTo(controller)
		.on("enter", function (e) {
			flyToFeatureExtent(geoJSONLayer.getSource());
			// vectorLayer4.setOpacity(1);
		})
		.on("leave", function (e) {
			// vectorLayer4.setOpacity(0);
		});

});
