package game.Inventory {
	import citrus.core.CitrusEngine;
	import citrus.view.starlingview.AnimationSequence;

	import game.Assets;
	import game.Player;
	import game.Weapon;
	import game.levels.EventByObject;
	import game.ui.LifeBar;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author Javier
	 */
	public class GameObject extends Sprite {
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		private static const WIDTH : int = 54;
		private static const HEIGHT : int = 44;
		private  var _objectProperties : Dictionary;
		private var _textureSprite : Image;
		private var _oldX : int;
		private var _oldY : int;
		private var _inventory : Inventory;
		private var _status : int;

		public function GameObject(properties : Dictionary) {
			width = WIDTH;
			height = HEIGHT;
			_inventory = Inventory.getInstance();
			addEventListener(TouchEvent.TOUCH, touchHandler);
			useHandCursor = true;
			name = properties['nameObject'];
			_objectProperties = properties;
			_textureSprite = new Image(Assets.getAtlas('objects').getTexture(_objectProperties['texture']));
			_textureSprite.x = 5;
			_textureSprite.y = 5;
			_textureSprite.width = WIDTH;
			_textureSprite.height = HEIGHT;
			_textureSprite.name = name + "-inventory";

			_oldX = _textureSprite.x;
			_oldY = _textureSprite.y;
			addChild(_textureSprite);

			_status = UNLOCKED;
		}

		public function setStatus(status : int) : void {
			_status = status;
		}

		public function getStatus() : int {
			return _status;
		}

		public function set(key : String, value : *) : void {
			_objectProperties[key] = value;
		}

		public function get(key : String) : * {
			return _objectProperties[key];
		}

		public function getAllProperties() : Dictionary {
			return _objectProperties;
		}

		private function touchHandler(e : TouchEvent) : void {
			var touch : Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnd : Touch = e.getTouch(this, TouchPhase.ENDED);
			var target : Quad = e.target as Quad;
			var item : * = null;
			if (touch) {
				var m_TouchMovedPoint : Point = new Point(touch.globalX, touch.globalY);
				parent.setChildIndex(this, numChildren + 1);
				var position : Point = touch.getLocation(this);
				target.x = position.x - 30;
				target.y = position.y - 30;

				this.touchable = false;
				item = stage.hitTest(m_TouchMovedPoint, true);

				if (item != null && item is Image && Image(item).name) {
					if (Image(item).name.indexOf("inventory") == -1 && _inventory.isVisible) {
						_inventory.hideInventory();
					}
				} else if (_inventory.isVisible && item != null && !((item is QuadBatch) && QuadBatch(item).name && QuadBatch(item).name == "slot") && !(item is Quad) ) {
					_inventory.hideInventory();
				} else if (_inventory.isVisible == false) {
					this.alpha = 1;
				}
			} else if (touchEnd) {
				this.touchable = true;
				var m_TouchEndedPoint : Point = new Point(touchEnd.globalX, touchEnd.globalY);
				parent.setChildIndex(this, numChildren - 1);
				item = stage.hitTest(m_TouchEndedPoint, true);
				if (item != null && item is Image && Image(item).name) {
					if (_objectProperties['union'] != "" && Image(item).name.indexOf(_objectProperties['union']) != -1) {
						_inventory.status(_objectProperties['resultObject'], UNLOCKED);
						_inventory.remove(_inventory.get(Image(item).name.replace("-inventory", "")));
						_inventory.remove(_inventory.get(this.name));
						_inventory.makeInventoryItems("key");
					} else if (_objectProperties['type'] == "item" || _objectProperties['type'] == "key") {
						this.useItem(m_TouchEndedPoint);
					} else if (_objectProperties['type'] == "weapon") {
						var weapon : Weapon = Weapon.getInstance();
						weapon.selectWeapon(name);
					}
				}

				if (_inventory.isVisible) {
					target.x = _oldX;
					target.y = _oldY;
				} else {
					this.touchable = true;
					target.x = _oldX;
					target.y = _oldY;
					_inventory.removeInventory();
				}
			} else {
				this.touchable = true;
				target.x = _oldX;
				target.y = _oldY;
			}
		}

		private function useItem(touchPoint : Point) : void {
			var action : String = _objectProperties['action'];

			switch(action) {
				case "heal":
					var lifeBar : LifeBar = LifeBar.getInstance();
					if (lifeBar.handleCure(_objectProperties['life'])) {
						_inventory.remove(this);
					}
					_inventory.makeInventoryItems("item");
					break;
				case "page":
					break;
				case "use":
					this.touchable = false;
					var ce : CitrusEngine = CitrusEngine.getInstance();
					var art : DisplayObject = stage.hitTest(touchPoint, true).parent;
					var player1 : Player = ce.state.getObjectByName("Player") as Player;
					if (art is AnimationSequence) {
						if (ce.state.view.getObjectFromArt(art.parent) is EventByObject) {
							var object : EventByObject = (ce.state.view.getObjectFromArt(art.parent)) as EventByObject;
							if (object.isTheKey(this)) {
								_inventory.remove(this);
								player1.talk(this.get("goodPlace"));
							} else {
								player1.talk(this.get("wrongPlace"));
							}
							_inventory.makeInventoryItems("key");
						}
					}
					this.touchable = true;
					break;
			}
		}

		override public function addChild(child : DisplayObject) : DisplayObject {
			return super.addChild(child);
		}
	}
}
