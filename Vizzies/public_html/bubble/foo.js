var accessors = {
  x : function x(d) { return d.elevation; },
  y : function y(d) { return d.volume; },
  thickness : function thickness(d) { return d.maxVolume; },
  color : function color(d) { return d.id; },
  key : function key(d) { return d.id; }
};
// Various accessors that specify the four dimensions of data to visualize.

var timeIndex = 0;
// Chart dimensions.
var margin = {top: 50, right: 50, bottom: 50, left: 100},
    smallestMargin = Object.values(margin).min();
    width = 960 - margin.right - margin.left,
    height = 500 - margin.top - margin.bottom,
    padding = 3,
    barColor = '#5092cc',
    //scale computed later dynamically based on available width
    thicknessScale = undefined,
    pixelsPerCapacity = undefined,
    //this is entirely fixed
    // xScale = d3.scale.ordinal(),
    yScale = d3.scale.linear().domain([0, 100]).range([height, 0]);

  var times = [];
  d3.json("../data/drought_shp/times.json", function(resp) {
    times = resp.d;
  });

// The x & y axes.
var yAxis = d3.svg.axis().scale(yScale).orient("left");

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
    // .call(xAxis);

// Add the y-axis.
svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

var dots = svg.append("g")
      .attr("class", "dots");

var setThicknessScale = function(pixelsPerCapacity){
  thicknessScale = function(t){
      return t*pixelsPerCapacity;
  };
};

  var reservoirs = [];

  function getDataAtTimestep(reservoirs, date) {
    var unfilteredReservoirs = reservoirs.map(function(d) {
      var currentStorage = d["Storage"][date];
      var maxStorage = d["Capacity"];
      
      var percentStorage = 100 * (currentStorage / maxStorage);
      var valToReturn;
      if(isNaN(percentStorage)){
          valToReturn = null;
      }
      else{
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
    filteredReservoirs = unfilteredReservoirs.filter(function(d){
        return d !== null && undefined !== d.volume;
    });
    return filteredReservoirs;
  };

  function paintGraph(data) {
    var dotData = dots.selectAll(".reservoir").data(data, accessors.key);

    dotData.enter().append("rect")
      .attr("class", "reservoir")
      .style("fill", function(d) { return barColor })
      .append("title").text(function(d) { return d.name; })
      .call(position);

    
    dotData.exit().remove();
    // Add a title.
    dotData.transition().ease('linear').call(position);
  }

    // Positions the dots based on data.
  function position(reservoir) {
    reservoir
    .attr("transform", function(d) {
      var xComponent = d.offset;
      var yComponent = height - yScale(accessors.y(d));
      return "translate(" + xComponent + "," +  yComponent + ")";
    })
    .attr("height", function(d) {
      var cy = yScale(accessors.y(d));
      return cy;
    })
    .attr("width", function(d) {
      var r = thicknessScale(accessors.thickness(d)); 
      return r;
    });
  }


// Load the data.
d3.json("../data/reservoirs/reservoir_storage.json", function(jsonReservoirs) {
  reservoirs = jsonReservoirs.sort(function(reservoir){
      return +reservoir["Elev"];
  });
  var getCapacity = function(reservoir){
    var capacity = +reservoir["Capacity"];
    capacity = isNaN(capacity) ? 0 : capacity;
    return capacity;
  };
  var totalCapacity = reservoirs.reduce(function(previous, reservoir){
      var capacity = getCapacity(reservoir);
      return previous + capacity;
  }, 0);

  pixelsPerCapacity = (width - padding*reservoirs.length) / totalCapacity;
  setThicknessScale(pixelsPerCapacity);
  for(var i = 0; i < reservoirs.length; i++){
      var preceedingOffset;
      if(i > 0){
          preceedingOffset = reservoirs[i-1].offset + (thicknessScale(getCapacity(reservoirs[i-1])));
      }
      else{
        preceedingOffset = 0;
      }
      var currentOffset = preceedingOffset + padding;
      reservoirs[i].offset = currentOffset;
  }
  timeIndex = reservoirs.length - 1;
});
