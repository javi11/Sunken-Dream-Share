package game {
	import org.osflash.signals.Signal;
	import starling.utils.Color;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.ICitrusArt;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import game.ui.MessageBox;

	import citrus.objects.platformer.box2d.Enemy;

	/**
	 * @author Javier
	 */
	public class AggressiveAI extends Enemy {
		private var _message : MessageBox;
		public var isTalking : Boolean = false;
		protected var _timer : Timer;
		[Inspectable(defaultValue="15000")]
		public var talkRate : Number = 10000;
		private var _numMessage : int = 0;
		private var _messages : Array;
		public var animationSequence : AnimationSequence;
		public var sensor:Sensor;
		public var onTakeDamage:Signal;
		public var onAnimationChange:Signal;
		
		public function AggressiveAI(name : String, params : Object = null) : void {
			super(name, params);
			//setView(params['texture']);
			if (params['talk']) {
				_messages = [params['talk1'], params['talk2'], params['talk3']];
				_timer = new Timer(talkRate);
				_timer.addEventListener(TimerEvent.TIMER, startTalking);
				_timer.start();
			}
			onTakeDamage = new Signal();
			onAnimationChange = new Signal();
			this.onTakeDamage.add(handleHeroTakeDamage);
			this.onAnimationChange.add(handleHeroAnimationChange);
			
			sensor = new Sensor(name+"Sensor",{width: 300, height:300, x:this.x, y:this.y});
			_ce.state.add(sensor);
		}

		private function setView(texture : String) : void {
			var animation : AnimationSequence = new AnimationSequence(Assets.getAtlas(texture), ["talk", "walk", "idle", "atack"], "walk");
			view = animation;
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
			sensor.x = this.x;
			sensor.y = this.y;
			_message.x = this.x;
			_message.y = this.y;
		}

		private function startTalking(tEvt : TimerEvent) : void {
			talk(_messages[_numMessage]);
			_animation = "talk";
			_numMessage++; 
			if(_numMessage >_messages.length) {
				_numMessage = 0;
			}
		}

		public function talk(text : String) : void {
			
			if (_message) {
				_ce.state.remove(_message);
				_message.destroy();
			}
			_message = new MessageBox("talk");
			_message.set(this.x - this.width * 3, this.y - this.height - 5, text,Color.BLUE);
			_ce.state.add(_message);
			isTalking = true;
		}

		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			if (animationName == "talk") {
				_animation = "walk";
			}
		}
		override protected function updateAnimation() :void {
				var prevAnimation:String = _animation;
				super.updateAnimation();
				if (prevAnimation != _animation)
					onAnimationChange.dispatch();
		}
		
		override public function destroy():void {
			sensor.kill = true;
			_message.kill = true;
			onTakeDamage.removeAll();
			onAnimationChange.removeAll();
			super.destroy();
		}
		
		private function handleHeroTakeDamage():void {
			_ce.sound.playSound("Hurt");
		}

		private function handleHeroAnimationChange():void {
			if (animation == "walk") {
				_ce.sound.playSound("Walk");
				return;
			} else {
				_ce.sound.stopSound("Walk");
			}
		}
	}
}
