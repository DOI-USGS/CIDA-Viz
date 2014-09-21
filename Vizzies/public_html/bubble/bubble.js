
// Various accessors that specify the four dimensions of data to visualize.
function x(d) { return d.elevation; }
function y(d) { return d.volume; }
function radius(d) { return d.maxVolume; }
function color(d) { return d.region; }
function key(d) { return d.name; }

// Chart dimensions.
var margin = {top: 19.5, right: 19.5, bottom: 19.5, left: 39.5},
    width = 960 - margin.right,
    height = 500 - margin.top - margin.bottom;

// Various scales. These domains make assumptions of data, naturally.
var xScale = d3.scale.linear().domain([0, 8500]).range([0, width]),
    yScale = d3.scale.linear().domain([0, 100]).range([height, 0]),
    radiusScale = d3.scale.sqrt().domain([10, 1000000]).range([2, 10]),
    colorScale = d3.scale.category10();

// The x & y axes.
var xAxis = d3.svg.axis().orient("bottom").scale(xScale)/*.ticks(12, d3.format(",d"))*/,
    yAxis = d3.svg.axis().scale(yScale).orient("left");

// Create the SVG container and set the origin.
var svg = d3.select("#chart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
     .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// Add the x-axis.
svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

// Add the y-axis.
svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

// Add an x-axis label.
svg.append("text")
    .attr("class", "x label")
    .attr("text-anchor", "end")
    .attr("x", width)
    .attr("y", height - 6)
    .text("elevation (m)");

// Add a y-axis label.
svg.append("text")
    .attr("class", "y label")
    .attr("text-anchor", "end")
    .attr("y", 6)
    .attr("dy", ".75em")
    .attr("transform", "rotate(-90)")
    .text("% capacity");

// Add the year label; the value is set on transition.
var label = svg.append("text")
    .attr("class", "year label")
    .attr("text-anchor", "end")
    .attr("y", height - 24)
    .attr("x", width)
    .text("20000104");

var timesteps = [];
$.ajax('../data/drought_shp/times.json', {
	success: function(data) {
		timesteps = data.d.reverse();
	}
});
// Load the data.
d3.json("../data/reservoirs/reservoir_storage.json", function(reservoirs) {

  // A bisector since many nation's data is sparsely-defined.
  var bisect = d3.bisector(function(d) { return d[0]; });

  // Add a dot per nation. Initialize the data at 1800, and set the colors.
  var dot = svg.append("g")
      .attr("class", "dots")
    .selectAll(".dot")
      .data(interpolateData("20000104"));

    dot.enter().append("circle")
      .attr("class", "dot")
      .style("fill", function(d) { return colorScale(color(d)); })
      .call(position)
      .sort(order);
  dot.exit().remove();
  // Add a title.
  dot.append("title")
      .text(function(d) { return d.name; });

  // Add an overlay for the year label.
  var box = label.node().getBBox();

   // Start a transition that interpolates the data based on year.
  // svg.transition()
  //     .duration(30000)
  //     .ease("linear")
  //     .tween("year", tweenYear)
  //     .each("end", enableInteraction);

  // Positions the dots based on data.
  function position(dot) {
    dot .attr("cx", function(d) { return xScale(x(d)); })
        .attr("cy", function(d) { return yScale(y(d)); })
        .attr("r", function(d) { return radiusScale(radius(d)); });
  }

  // Defines a sort order so that the smallest dots are drawn on top.
  function order(a, b) {
    return radius(b) - radius(a);
  }

  // Tweens the entire chart by first tweening the year, and then the data.
  // For the interpolated data, the dots and label are redrawn.
  function tweenYear() {
    var year = d3.interpolateNumber(1800, 2009);
    return function(t) { displayYear(year(t)); };
  }

  // Updates the display to show the specified year.
  function displayYear(year) {
    var interpolatedData = interpolateData(year);
    var dotData = dot.data(interpolatedData, key);
    dotData.exit().remove();
    dotData.call(position).sort(order);
    label.text(Math.round(year));
  }
  
  var timestepCounter = 0;
  setInterval(function(){
    displayYear(timesteps[timestepCounter]);
    timestepCounter += 1;
  }, 1000);

  // Interpolates the dataset for the given (fractional) year.
  function interpolateData(timestep) {
    //var truncatedYear = year.toFixed(0);
    //var strDate = '' + timestep;
    var unfilteredReservoirs = reservoirs.map(function(d) {
      return {
        name: d.Station,
        region: d.ID,
        elevation: d.Elev,
        maxVolume: d.Capacity,
        volume: d.Storage[timestep] / d.Capacity * 100
      };
    });
    filteredReservoirs = unfilteredReservoirs.filter(function(d){
        return undefined !== d.volume;
    });
    return filteredReservoirs;
  }
});
