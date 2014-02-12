package game {
	import org.osflash.signals.Signal;

	import citrus.objects.platformer.box2d.Platform;
	import citrus.math.MathVector;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;

	import flash.geom.Point;

	import game.weapons.Cannon;

	import Box2D.Dynamics.Contacts.b2Contact;

	import starling.utils.Color;

	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.ICitrusArt;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import game.ui.MessageBox;

	import citrus.objects.platformer.box2d.Enemy;

	/**
	 * @author Javier
	 */
	public class PassiveAI extends Enemy {
		private var _message : MessageBox;
		public var isTalking : Boolean = false;
		public var isAttacking : Boolean = false;
		protected var _timer : Timer;
		[Inspectable(defaultValue="15000")]
		public var talkRate : Number = 10000;
		private var _numMessage : int = 0;
		private var _messages : Array;
		public var animationSequence : AnimationSequence;
		private var _life : int;
		private var _damage : int;
		private var speedTemp: Number;
		protected var _enemy:IBox2DPhysicsObject = null;
		public var onTakeDamage:Signal;
		public var onAnimationChange:Signal;

		public function PassiveAI(name : String, params : Object = null) : void {
			super(name, params);
			setView(params['texture']);
			endContactCallEnabled = true;
			if (params['talk']) {
				_messages = [params['talk1'], params['talk2'], params['talk3']];
				_timer = new Timer(talkRate);
				_timer.addEventListener(TimerEvent.TIMER, startTalking);
				_timer.start();
			}
			_life = params['life'];
			_damage = params['damage'];
			speedTemp = speed;
			onTakeDamage = new Signal();
			onAnimationChange = new Signal();
			this.onTakeDamage.add(handleHeroTakeDamage);
			this.onAnimationChange.add(handleHeroAnimationChange);
			
		}

		private function setView(texture : String) : void {
			var animationseq : AnimationSequence = new AnimationSequence(Assets.getAtlas(texture), ["talk", "walk", "idle", "atack","surprise"], "walk");
			view = animationseq;
			_animation = "walk";
		}

		override public function update(timeDelta : Number) : void {
			if (_message) {
				_message.x = this.x - this.width * 3;
			}
			super.update(timeDelta);
			updateAnimation();
		}
		
		override protected function updateAnimation():void
		{
				var prevAnimation:String = _animation;
				if (prevAnimation != _animation)
					onAnimationChange.dispatch();
		}

		private function startTalking(tEvt : TimerEvent) : void {
			talk(_messages[_numMessage]);
			_animation = "talk";
			_numMessage++;
			if (_numMessage >= _messages.length) {
				_numMessage = 0;
			}
		}

		public function talk(text : String) : void {
			if (_message) {
				_ce.state.remove(_message);
				_message.destroy();
			}
			_message = new MessageBox("talk");
			_message.set(this.x - this.width * 3, this.y - this.height - 5, text, Color.BLUE);
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
				isTalking = false;
				_message.kill = true;
			} else if (animationName == "atack") {
				_animation = "walk";
				isAttacking = false;
				_timer.start();
				speed = speedTemp;
				y -=1;
				if(_enemy && _enemy is Player) {
					if(!(Player)(_enemy).isAttacking)
						(Player)(_enemy).handleDamage(_damage,this);
					_enemy = null;
				}
				
			} else if(animationName == "surprise") {
				_animation = "atack";
				isAttacking = true;
			}
			
		}

		public function handleDamage(damage : int) : void {
			onTakeDamage.dispatch();
			_life -= damage;
			if (_life <= 0) {
				_life = 0;
				this.hurt();
			} else {
				_animation = "surprise";
			}
		}

		override public function handleBeginContact(contact : b2Contact) : void {
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			var hurt : int = returnBodyIfCanHurt(collider);
			if (hurt != 0) {
				handleDamage(hurt);
			}
			_enemy = collider;
			if (collider is Player && !isAttacking && speed != 0) {
				_timer.stop();
				if(_message)
					_message.kill = true;
				_animation = "surprise";
				if(speed != 0)
					speedTemp = speed;
				speed = 0;
			}

			if (_body.GetLinearVelocity().x < 0 && (contact.GetFixtureA() == _rightSensorFixture || contact.GetFixtureB() == _rightSensorFixture))
				return;

			if (_body.GetLinearVelocity().x > 0 && (contact.GetFixtureA() == _leftSensorFixture || contact.GetFixtureB() == _leftSensorFixture))
				return;

			if (contact.GetManifold().m_localPoint) {
				var normalPoint : Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle : Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;

				if ((collider is Platform && collisionAngle != 90) || collider is Enemy || collider is PhysicBox) {
					turnAround();
				}
			}
		}
		override public function handleEndContact(contact : b2Contact) : void {
			if(_enemy) {
				_enemy = null;
			}
		}
		
		private function returnBodyIfCanHurt(collider : IBox2DPhysicsObject) : int {
			if (collider is Cannon )
				return (Cannon)(collider).getDamage();
			else if (collider is Cannon)
				return (Cannon)(collider).getDamage();
			else if (collider is Player &&( (Player)(collider).isShooting || (Player)(collider).isAttacking))
				return (Player)(collider).getDamage();
			else
				return 0;
		}

		override public function destroy() : void {
			if(_message)
				_message.kill = true;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, startTalking);
			onTakeDamage.removeAll();
			onAnimationChange.removeAll();
			super.destroy();
		}

		public function getDamage() : int {
			return _damage;
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
