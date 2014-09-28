ScrollControl = function() {
	var createControlDiv = function(el) {
		
		//play button
	};
	
	var control = function(config) {
		this.scrollRate = config.scrollRate || 500;
		this.scrollStep = config.scrollStep || 20;
		this.parent = config.parent || document.body;
		this.action = null;
		this.createControlDiv();
		this.body = $("html, body");
	}
	
	control.prototype.createControlDiv = function() {

		var div = $('<div>');
		div.addClass('scroll-control-container');
		
		//rev button
		var reverse = $('<i>');
		reverse.addClass('fa');
		reverse.addClass('fa-backward');
		reverse.on('click', $.proxy(this.reverse, this));
		this.reverseBtn = reverse;
		
		//pause button
		var pause = $('<i>');
		pause.addClass('fa');
		pause.addClass('fa-pause');
		pause.on('click', $.proxy(this.pause, this));
		this.pauseBtn = pause;
		
		//play button
		var play = $('<i>');
		play.addClass('fa');
		play.addClass('fa-play');
		play.on('click', $.proxy(this.play, this));
		this.playBtn = play;
		
		div.append(reverse);
		div.append(pause);
		div.append(play);
		
		//help text
		var help = $('<p>');
		help.html("Hit \"play\"<br/>or scroll at<br/>your own<br/>pace!");
		div.append(help);
		
		this.pauseBtn.hide();
		this.parent.append(div);
		
		var _this = this;
	}
	
	control.prototype.getScrollPos = function() {
		return window.pageYOffset || document.documentElement.scrollTop;
	};
	
	control.prototype.scrollBy = function(offset, rate, expectedAction) {
		this.body.stop();
		var curPos = this.getScrollPos();
		var goPos = curPos + offset;
		var _this = this;
		if(goPos >= 0 && goPos <= (this.height) && _this.action == expectedAction) {
			this.body.animate({scrollTop:goPos}, rate, 'linear', function(){
	
				var newPos = _this.getScrollPos();
				var change = Math.abs(newPos - curPos);
				if( change > rate ) { //this happens when something external did the scroll
					_this.pause();
				}
				
				if(_this.action == expectedAction) {
					$.proxy(function(){_this.scrollBy(offset, rate, expectedAction)}, _this)();
				} 
			});
		} else {
			_this.pause();
		}
	}
	
	control.prototype.play = function() {
		this.pauseBtn.show();
		this.playBtn.hide();
		this.action = "play";
		this.height = $(document).height() - $(window).height();
		this.scrollBy(this.scrollStep, this.scrollRate, "play");
	}
	
	control.prototype.pause = function() {
		this.body.stop();
		this.action = null;
		this.playBtn.show();
		this.pauseBtn.hide();
	}
	
	control.prototype.reverse = function() {
		this.pauseBtn.show();
		this.playBtn.hide();
		this.action = "reverse";
		this.height = $(document).height() - $(window).height();
		this.scrollBy(-1 * this.scrollStep, this.scrollRate, "reverse");
	}
	
	return control;
}();