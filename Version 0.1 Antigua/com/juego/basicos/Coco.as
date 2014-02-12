package com.juego.basicos
{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.trace.Trace;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Coco extends MovieClip
	{
		private var _player:MovieClip;
		private var _lv:MovieClip;
		private var _velocidad:Number = 16;
		private var _dirX = Math.cos(-30*Math.PI/180)*35;
		private var _dirY = Math.sin(-30*Math.PI/180)*35;
		private var _direccion:Number;
		private var _gravedad:Number;
		private var _gameTimer:Timer;
		private var _colision:Boolean;
		
		public function Coco (player:MovieClip, x:Number, y:Number,dir:Number,grav:Number,lv:MovieClip) : void
		{
			_player = player;
			_lv = lv;
			this.x = x;
			this.y = y;
			_direccion = dir;
			_colision = false;
			_gravedad = grav;
			_gameTimer = new Timer( 25 );
			_gameTimer.addEventListener( TimerEvent.TIMER, Update, false, 0, true );
			_gameTimer.start();
		}
		
		private function Update(e:Event) : void
		{
			for (var i:uint = 0; i < _lv.numChildren; i++){
				var block:MovieClip = _lv.getChildAt(i) as MovieClip;
				if(this.hitTestObject(block)) {
					this.gotoAndStop("explosion");
					checkTimeline();		
					_colision = true;
					break;
				}
			}
			if (this.y > _player.y+280) {
				this.gotoAndStop("explosion");
				checkTimeline();	
			} else if (this.x >  _player.x+280) {
				this.gotoAndStop("explosion");
				checkTimeline();	
			} else if(!_colision) {
				_dirY -= _gravedad;
				this.y += _dirY;
				this.x += _direccion*_dirX/2;
				this.rotation += 20;
			}
			
		}
		private function checkTimeline() {
			if (this._explosionCoco.currentFrame == this._explosionCoco.totalFrames) {
				this.removeSelf();
			}
		}				
		public function removeSelf() : void
		{
			_gameTimer.stop();
			if (parent.contains(this)) {
				parent.removeChild(this);
			}
					
		}
		
	}
	
}