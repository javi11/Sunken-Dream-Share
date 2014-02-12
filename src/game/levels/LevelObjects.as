package game.levels {
	import Box2D.Dynamics.Contacts.b2Contact;

	import citrus.objects.platformer.box2d.Coin;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;

	import game.Assets;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.Player;

	import starling.textures.Texture;

	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;

	/**
	 * @author laris11
	 */
	public class LevelObjects extends Coin {
		public var onBeingCollected : Signal;
		private var inventory : Inventory;
		private var _objectProperties : Dictionary;
		private var _name : String;
		private var _texture : Texture;
		private var _dir : Number;
		private var _moviment : Number;

		public function LevelObjects(name : String, params : Object = null) : void {
			super(name, params);
			x = params['x'];
			y = params['y'];
			_objectProperties = new Dictionary();
			if (params['properties']) {
				_objectProperties = xmlToDictionary(params['properties']);
			} else {
				_objectProperties = objectToDictionary(params);
			}
			_texture = Assets.getAtlas('objects').getTexture(_objectProperties['texture']);
			inventory = Inventory.getInstance();

			_collectorClass = Player;
			_name = _objectProperties['nameObject'];

			onBeingCollected = new Signal(LevelObjects);
			view = _texture;
			updateCallEnabled = true;
			_dir = +0.1;
			_moviment = 0;
		}

		private function objectToDictionary(properties : Object) : Dictionary {
			var tempProperties : Dictionary = new Dictionary();
			for (var param : String in properties) {
				tempProperties[param] = properties[param];
			}
			return tempProperties;
		}

		private function xmlToDictionary(item : XMLList) : Dictionary {
			var tempProperties : Dictionary = new Dictionary();
			for each (var property : XML in item.children()) {
				tempProperties[property.name()] = property;
			}
			return tempProperties;
		}

		override public function handleBeginContact(contact : b2Contact) : void {
			var collider : IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (_collectorClass && collider is _collectorClass) {
				_ce.sound.playSound("Collect");
				onBeingCollected.dispatch(this);
				inventory.add(new GameObject(_objectProperties));
				kill = true;
			}
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
			if (_moviment > 5) {
				_dir = -0.1;
			} else if (_moviment < 0) {
				_dir = +0.1;
			}
			this.y += _dir;
			_moviment += _dir;
		}
	}
}

