
// Various accessors that specify the four dimensions of data to visualize.
function x(d) { return d.elevation; }
function y(d) { return d.volume; }
function thickness(d) { return d.maxVolume; }
function color(d) { return d.id; }
function key(d) { return d.id; }

// Chart dimensions.
var margin = {top: 50, right: 50, bottom: 50, left: 100},
    smallestMargin = Object.values(margin).min();
    width = 960 - margin.right - margin.left,
    height = 500 - margin.top - margin.bottom,
    padding = 3,
    //scale computed later dynamically based on available width
    thicknessScale = undefined,
    pixelsPerCapacity = undefined,
    //this is entirely fixed
    xScale = d3.scale.ordinal(),
    yScale = d3.scale.linear().domain([0, 100]).range([height, 0]);
  var dateCounterStart = Date.create("January 4, 2000");
  var dateCounter = dateCounterStart.clone();
  var dateDisplayFormat = '{yyyy}-{MM}-{dd}';
  var formatDateForDisplay = function(date){
      return date.format(dateDisplayFormat);
  };
var getMaxElevation = function(reservoirs){
  return getExtremeElevation('max', reservoirs);
};
var getMinElevation = function(reservoirs){
  return getExtremeElevation('min', reservoirs);
};

var getExtremeElevation = function(minOrMax, reservoirs){
  return getExtremeProperty(minOrMax, reservoirs, 'Elev');
};


var getMinCapacity = function(reservoirs){
  return getExtremeCapacity('min', reservoirs);
};

var getMaxCapacity = function(reservoirs){
  return getExtremeCapacity('max', reservoirs);
};

var getExtremeCapacity = function(minOrMax, reservoirs){
  return getExtremeProperty(minOrMax, reservoirs, 'Capacity');
};

/**
 * get either max or min
 * @param {String} minOrMax - one of 'min' or 'max'
 * @param {Array} reservoirs - an array of reservoir objects
 * @param {String} propertyName - name of property to examine
 */
var getExtremeProperty = function(minOrMax, reservoirs, propertyName){
  return reservoirs[minOrMax](function(reservoir){return reservoir[propertyName];})[propertyName];
};


// var setXscale = function(elevations, displayMax){
//   xScale = d3.scale.ordinal().domain(elevations).rangeBands([0, displayMax]);
// };

var setThicknessScale = function(pixelsPerCapacity){
  thicknessScale = function(t){
      return t*pixelsPerCapacity;
  };
};


// Load the data.
// d3.json("abbrev.reservoirs.json", function(reservoirs) {
d3.json("../../../ca_reservoirs/storage_data/reservoir.json", function(reservoirs) {
    // reservoirs = [
    //   {
    //     "Capacity" : 100,
    //     "Elev": 1,
    //     "Storage" : {
    //       "20000104" : 40,
    //       "20000111" : 80
    //     } 
    //   },
    //   {
    //     "Capacity" : 100,
    //     "Elev": 2,
    //     "Storage" : {
    //       "20000104" : 100,
    //       "20000111" : 20
    //     } 
    //   },
    // ];
    //perform multiple linear scans over reservoirs to determine dataset ranges
    //@todo: optimize to one-pass scan later if needed
    reservoirs = reservoirs.sort(function(reservoir){
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
    
    var reservoirIds = reservoirs.map(function(reservoir){return reservoir.ID;});
    colorScale = d3.scale.ordinal().domain(reservoirIds).range(d3.scale.category20().range());

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

var dots = svg.append("g")
      .attr("class", "dots")

// Add the year label; the value is set on transition.
var label = svg.append("text")
    .attr("class", "year label")
    .attr("text-anchor", "end")
    .attr("y", height - 24)
    .attr("x", width)

  // A bisector since many nation's data is sparsely-defined.
  var bisect = d3.bisector(function(d) { return d[0]; });

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
    dot.attr("transform", function(d) {
      var xComponent = d.offset;
      var yComponent = height - yScale(y(d));
      return "translate(" + xComponent + "," +  yComponent + ")";
    })
    .attr("height", function(d) {
      var cy = yScale(y(d)); 
      return cy;
    })
    .attr("width", function(d) {
      var r = thicknessScale(thickness(d)); 
      return r;
    });
  }

  // Defines a sort order so that the smallest dots are drawn on top.
  function order(a, b) {
    return thickness(b) - thickness(a);
  }

  // Tweens the entire chart by first tweening the year, and then the data.
  // For the interpolated data, the dots and label are redrawn.
  function tweenYear() {
    var year = d3.interpolateNumber(2000, 2014);
    return function(t) { displayYear(year(t)); };
  }

  // Updates the display to show the specified year.
  function displayYear(date) {
    var interpolatedData = interpolateData(date);
    var dotData = dots.selectAll(".dot").data(interpolatedData, key);

    dotData.enter().append("rect")
      .attr("class", "dot")
      .style("fill", function(d) { return colorScale(color(d)); })
      .append("title").text(function(d) { return d.name; })
      .call(position);

    
    dotData.exit().remove();
    // Add a title.
    dotData.transition().ease('linear').call(position);
    dotData.sort(order);
    label.text(formatDateForDisplay(date));
  }
  // Interpolates the dataset for the given (fractional) year.
  var dateLookupFormat = '{yyyy}{MM}{dd}';
  function interpolateData(date) {
    var dateLookupKey = date.format(dateLookupFormat);
    var unfilteredReservoirs = reservoirs.map(function(d) {
      var currentStorage = d["Storage"][dateLookupKey];
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

setInterval(function(){
  displayYear(dateCounter);
  dateCounter = dateCounter.advance('1 week');
}, 100);
displayYear(dateCounter);

});
