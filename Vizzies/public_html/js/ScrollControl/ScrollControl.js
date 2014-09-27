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
		
		this.pauseBtn.hide();
		this.parent.append(div);
	}
	
	control.prototype.getScrollPos = function() {
		return window.pageYOffset || document.documentElement.scrollTop;
	};
	
	control.prototype.scrollBy = function(offset, rate, expectedAction) {
		var body = $("html, body");

		body.stop();
		var newPos = this.getScrollPos() + offset;
		var _this = this;
		body.animate({scrollTop:newPos}, rate, 'linear', function(){
			if(_this.action == expectedAction) {
				$.proxy(function(){_this.scrollBy(offset, rate, expectedAction)}, _this)();
			}
		});
	}
	
	control.prototype.play = function() {
		this.pauseBtn.show();
		this.playBtn.hide();
		this.action = "play";
		this.scrollBy(this.scrollStep, this.scrollRate, "play");
	}
	
	control.prototype.pause = function() {
		this.pauseBtn.hide();
		this.playBtn.show();
		this.action = null;
	}
	
	control.prototype.reverse = function() {
		this.pauseBtn.show();
		this.playBtn.hide();
		this.action = "reverse";
		this.scrollBy(-1 * this.scrollStep, this.scrollRate, "reverse");
	}
	
	return control;
}();