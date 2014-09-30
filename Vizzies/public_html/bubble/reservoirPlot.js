var reservoirPlot = new (function ReservoirPlot(chartSelector) {
	var that = this;
	var accessors = {
		x: function x(d) {
			return d.elevation;
		},
		y: function y(d) {
			return d.volume;
		},
		thickness: function thickness(d) {
			return d.maxVolume;
		},
		color: function color(d) {
			return d.id;
		},
		key: function key(d) {
			return d.id;
		}
	};

	// Chart dimensions.
	var margin = {
		top: 50,
		right: 50,
		bottom: 10,
		left: 30
	};
	var smallestMargin = Object.values(margin).min();
	var width = 600 - margin.right - margin.left;
	var height = 400 - margin.top - margin.bottom;
	var padding = 3;
	var barColor = '#5092cc';
	//scale computed later dynamically based on available width
	var thicknessScale = undefined;
	var pixelsPerCapacity = undefined;
	// xScale = d3.scale.ordinal(),
	var yScale = d3.scale.linear().domain([0, 100]).range([height, 0]);

	var timeIndex = -1;
	var times = [];
	d3.json("data/drought_shp/times.json", function(resp) {
		times = resp.d;
	});

	var yAxis = d3.svg.axis().scale(yScale).orient("left").ticks(4);

	var svg = d3.select(chartSelector).append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
		.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	// Add the x-axis.
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + height + ")")
	// .call(xAxis);

	// Add the y-axis.
	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis);

	var dots = svg.append("g")
		.attr("class", "dots");

	var reservoirs = [];


	this.getDataAtTimestep = (function getDataAtTimestep(reservoirData, date) {
		if (!reservoirData) {
			reservoirData = reservoirs;
		}
		var unfilteredReservoirs = reservoirData.map(function(d) {
			var currentStorage = d["Storage"][date];
			var maxStorage = d["Capacity"];

			var percentStorage = 100 * (currentStorage / maxStorage);
			var valToReturn;
			if (isNaN(percentStorage)) {
				valToReturn = null;
			} else {
				valToReturn = {
					id: d.ID,
					name: d["Station"],
					region: d["County"],
					elevation: d["Elev"],
					maxVolume: maxStorage,
					volume: percentStorage,
					offset: d.offset
				};
			}
			return valToReturn;
		});
		filteredReservoirs = unfilteredReservoirs.filter(function(d) {
			return d !== null && undefined !== d.volume;
		});
		return filteredReservoirs;
	});

	this.paintGraph = (function paintGraph(data) {
		if (data && 0 < data.length) {
			var dotData = dots.selectAll(".reservoir").data(data, accessors.key);

			dotData.enter().append("rect")
				.attr("class", "reservoir")
				.style("fill", function(d) {
					return barColor
				})
				.append("title").text(function(d) {
					return d.name;
				})
				.call(position);


			dotData.exit().remove();
			// Add a title.
			dotData.transition().ease('linear').call(position);
		}
	});

	this.paintNextGraph = (function paintNextGraph() {
		var nextTimeIndex = timeIndex--;
		if (0 > nextTimeIndex) {
			timeIndex = times.length - 1;
			nextTimeIndex = timeIndex--;
		}
		that.paintGraph(that.getDataAtTimestep(reservoirs, times[nextTimeIndex]));
	});

	// Positions the dots based on data.
	var position = (function position(reservoir) {
		reservoir
			.attr("transform", function(d) {
				var xComponent = d.offset;
				var yComponent = height - yScale(accessors.y(d));
				return "translate(" + xComponent + "," + yComponent + ")";
			})
			.attr("height", function(d) {
				var cy = yScale(accessors.y(d));
				return cy;
			})
			.attr("width", function(d) {
				var r = thicknessScale(accessors.thickness(d));
				return r;
			});
	});


	// Load the data.
	d3.json("data/reservoirs/reservoir_storage.json", function(jsonReservoirs) {
		reservoirs = jsonReservoirs.sort(function(reservoir) {
			return +reservoir["Elev"];
		});
		var getCapacity = function(reservoir) {
			var capacity = +reservoir["Capacity"];
			capacity = isNaN(capacity) ? 0 : capacity;
			return capacity;
		};
		var totalCapacity = reservoirs.reduce(function(previous, reservoir) {
			var capacity = getCapacity(reservoir);
			return previous + capacity;
		}, 0);

		pixelsPerCapacity = (width - padding * reservoirs.length) / totalCapacity;
		thicknessScale = function(t) {
			return t * pixelsPerCapacity;
		};

		for (var i = 0; i < reservoirs.length; i++) {
			var preceedingOffset;
			if (i > 0) {
				preceedingOffset = reservoirs[i - 1].offset + (thicknessScale(getCapacity(reservoirs[i - 1])));
			} else {
				preceedingOffset = 0;
			}
			var currentOffset = preceedingOffset + padding;
			reservoirs[i].offset = currentOffset;
		}
	});
})("#res-plot");