(function(){
	var chart;
	nv.addGraph(function() {
	  chart = nv.models.scatterChart()
					.showDistX(true)
					.showDistY(true)
					.useVoronoi(true)
					.color(['#D9D919','#FFA824','#66CD00'])
					.transitionDuration(300)
					;

	  chart.xAxis     //Chart x-axis settings
		.axisLabel('Percent of state in severe drought (%)')
		.tickFormat(d3.format('.02f'));
	  chart.yAxis     //Chart x-axis settings
		.axisLabel('Price anomaly ($ per pound)')
		.tickFormat(d3.format('.02f'));

	  chart.tooltipContent(function(key) {
		  return '<h2>' + key + '</h2>';
	  });

	  d3.select('#ag-prices svg')
		  .datum(randomData(3,1))
		  .call(chart);

	  nv.utils.windowResize(chart.update);

	  chart.dispatch.on('stateChange', function(e) { ('New State:', JSON.stringify(e)); });

	  return chart;
	});


	function randomData(groups, points) { //# groups,# points per group
	  var data = [],
		  shapes = ['circle', 'cross', 'triangle-up', 'triangle-down', 'diamond', 'square'],
		  names = ['Lemons','Navel oranges','Lettuce','turtle'],
		  colors = ['#D9D919','#FFA824','#66CD00']
		  random = d3.random.normal(),
		  yr_num = 6,
		  sz = 12,
		  v1 = [1.52,1.63425,1.580666667,1.5645,1.568454545,1.862125],
		  v2 = [1.050416667,1.06175,1.09575,1.053166667,1.134636364,1.279375],
		  v3 = [0.913333333,0.874666667,0.988833333,0.857,1.014636364,0.99975],
		  x = [36.34945833,3.2115,0,21.84895833,59.69709091,95.655625];
		var v1_avg = 0,
			v2_avg = 0,
			v3_avg = 0;
		for(var i = 0; i < v1.length; i++){
			v1_avg += v1[i];
			v2_avg += v2[i];
			v3_avg += v3[i];

		}
		v1_avg = v1_avg/v1.length;
		v2_avg = v2_avg/v2.length;
		v3_avg = v3_avg/v3.length;
	  for (var i = 0; i < groups; i++) {
		data.push({
		  key: names[i],
		  values: []
		});
	}
	for (var j = 0; j < yr_num; j++) {
		data[0].values.push({
			x: x[j],
			y: v1[j]-v1_avg,
			size: sz,
			color: colors[0],
			shape: shapes[0]
		  });
	}
	data[0].values.push({
		x: null,
		y: null,
		r: null,
		shape: shapes[0]
	  });
	for (var j = 0; j < yr_num; j++) {
		data[1].values.push({
			x: x[j],
			y: v2[j]-v2_avg,
			size: sz,
			color: colors[1],
			shape: shapes[0]
		  });
	}
	data[1].values.push({
		x: null,
		y: null,
		r: null,
		shape: shapes[0]
	  });
	for (var j = 0; j < yr_num; j++) {
		data[2].values.push({
			x: x[j],
			y: v3[j]-v3_avg,
			size: sz,
			color: colors[2],
			shape: shapes[0]
		  });
	}

		data[2].values.push({
			x: null,
			y: null,
			r: null,
			shape: shapes[0]
		  });

	  return data;
	}
}())