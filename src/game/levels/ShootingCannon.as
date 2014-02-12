package game.levels {
	import citrus.view.ICitrusArt;
	import Box2D.Common.Math.b2Vec2;
	import game.weapons.Cannon;
	import game.Assets;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.Box2DPhysicsObject;

	import org.osflash.signals.Signal;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Cañon que dispara misiles
	 */
	public class ShootingCannon extends Platform {
		/**
		 * La frecuencia en la que son disparados
		 */
		[Inspectable(defaultValue="2000")]
		public var fireRate : Number = 2000;
		/**
		 * La dirección donde son disparados
		 */
		[Inspectable(defaultValue="right",enumeration="right,left")]
		public var startingDirection : String = "right";
		/**
		 * Indica si el cañon dispara al comenzar o no
		 */
		[Inspectable(defaultValue="true")]
		public var openFire : Boolean = true;
		[Inspectable(defaultValue="20")]
		private var _damage:int = 20;
		/**
		 * Salta si explota con un objeto box2D
		 */
		public var onGiveDamage : Signal;
		protected var _firing : Boolean = false;
		protected var _timer : Timer;
		private var _activeView : String;
		private var _idleView : String;
		public var animationSequence : AnimationSequence;
		public function ShootingCannon(name : String, params : Object = null) {
			super(name, params);
			_activeView = params['texture']+"active";
			_idleView = params['texture']+"idle";
			onGiveDamage = new Signal(Box2DPhysicsObject);
			animationSequence = new AnimationSequence(Assets.getAtlas('levelA' + params['lv'] + 'Events'), [_idleView,_activeView], _idleView);
			view = animationSequence;
		}

		override public function initialize(poolObjectParams : Object = null) : void {
			super.initialize(poolObjectParams);

			if (openFire)
				startFire();
		}

		override public function destroy() : void {
			onGiveDamage.removeAll();
			_ce.onPlayingChange.remove(_playingChanged);

			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _fire);

			super.destroy();
		}

		/**
		 * El cañon comienza a disparar
		 */
		public function startFire() : void {
			_firing = true;
			_updateAnimation();

			_timer = new Timer(fireRate);
			_timer.addEventListener(TimerEvent.TIMER, _fire);
			_timer.start();

			_ce.onPlayingChange.add(_playingChanged);
		}

		/**
		 * El cañon para de disparar
		 */
		public function stopFire() : void {
			_firing = false;
			_updateAnimation();

			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _fire);

			_ce.onPlayingChange.remove(_playingChanged);
		}

		/**
		 * El cañon dispara un misil
		 */
		protected function _fire(tEvt : TimerEvent) : void {
			_animation = _activeView;
			var missile : Cannon;
			
			if (startingDirection == "right")
				missile = new Cannon("Missile", x + width-40, y-20, "cannon",_damage,new b2Vec2(2.7, -0.5));
			else
				missile = new Cannon("Missile", x - width+40, y-20, "cannon",_damage,new b2Vec2(-2.7, -0.5));
			
			_ce.state.add(missile);
		}
		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			if (animationName == _activeView) {
				_animation = _idleView;
			}
		}

		protected function _updateAnimation() : void {
			_animation = _firing ? _activeView : _idleView;
			
		}

		/**
		 * Parar o encender el cañon automaticamente por el juego.
		 */
		protected function _playingChanged(playing : Boolean) : void {
			playing ? _timer.start() : _timer.stop();
		}
	}
}
