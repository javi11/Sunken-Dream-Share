package game.weapons {
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;

	import citrus.objects.Box2DPhysicsObject;
	import citrus.view.ICitrusArt;
	import citrus.view.starlingview.AnimationSequence;

	import game.Assets;

	public class Cannon extends Box2DPhysicsObject {
		public var animationSequence : AnimationSequence;
		public var dying : Boolean = false;
		public var _collisionY : int;
		public var _impulse : b2Vec2;
		private var _texture : String;
		protected var _friction : Number;
		private var _damage:int;

		public function Cannon(name : String, posX : int, posY : int, texture : String,damage:int , impulse : b2Vec2 = null, friction : Number = 0.75) {
			var params : Object = {x:posX, y:posY};
			super(name, params);
			
			// allow update calls
			updateCallEnabled = true;
			// allow calls to the handleBeginContact function when something hits the object
			beginContactCallEnabled = true;
			_texture = texture;
			setView(texture);
			_friction = friction;
			_impulse = impulse;
			_damage = damage;	
		}
		public function getDamage(): int{
			return _damage;
		}

		private function setView(texture : String) : void {
			var animation : AnimationSequence = new AnimationSequence(Assets.getAtlas('weapons'), [texture + "explosion", texture + "idle"], texture + "idle");
			view = animation;
		}

		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			if (animationName == _texture + "explosion") {
				kill = true;
			}
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
			if(_impulse)
				_body.ApplyImpulse(_impulse, _body.GetLocalCenter());
			if (_animation == _texture + "explosion") {
				y = _collisionY;
			} else {
				this.rotation += 20;
			}
		}

		override public function handleBeginContact(contact : b2Contact) : void {
			super.handleBeginContact(contact);
			_animation = _texture + "explosion";

			_collisionY = y;
			velocity = [0, 0];
			
			
		}

		override public function destroy() : void {
			// make sure to remove the handleAnimationComplete listener from the onAnimationComplete signal
			if (animationSequence)
				animationSequence.onAnimationComplete.remove(handleAnimationComplete);
			animationSequence = null;
			super.destroy();
		}

		override protected function defineBody() : void {
			super.defineBody();

			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}

		override protected function createShape() : void {
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.1);
		}

		override protected function defineFixture() : void {
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Items");
		}
	}
}