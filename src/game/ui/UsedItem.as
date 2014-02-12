package game.ui {
	import starling.display.DisplayObject;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.ObserverManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	/**
	 * @author Javier
	 */
	public class UsedItem extends Sprite {
		private var _itemBox : Image;
		private var _usedItemImg : Image;
		private var _usedItem : GameObject;
		protected var observer : ObserverManager;
		private static var _instance : UsedItem;
		private var _inventory : Inventory;
		public var playerSensor : Boolean = false;

		public function UsedItem() : void {
			_inventory = Inventory.getInstance();
		}

		public function getItem() : GameObject {
			return _usedItem;
		}

		public static function getInstance() : UsedItem {
			if (!_instance) {
				_instance = new UsedItem();
			}
			return _instance;
		}

		public function addTexture(Texture : TextureAtlas) : void {
			_itemBox = new Image(Texture.getTexture("itemUsado"));
			_itemBox.x = -100;
			addChild(_itemBox);
			observer = observer = ObserverManager.getInstance();
		}

		public function set(textureItem : TextureAtlas, itemObject : Object) : void {
			_usedItem = itemObject as GameObject;
			removeChild(_usedItemImg);
			_usedItemImg = new Image(textureItem.getTexture(_usedItem.get('texture')));
			_usedItemImg.x = -87;
			_usedItemImg.y = 12;
			addChild(_usedItemImg);
		}

		public function useItem() : Boolean{
			if (_usedItem != null) {
				var action : String = _usedItem.get("action");

				switch(action) {
					case "heal":
						_inventory.remove(_usedItem);
						var life : Object = {hp:_usedItem.get("life")};
						observer.notify(life);
						break;
					case "page":
						break;
					case "use":
						playerSensor = true;
						break;
				}

				if (_inventory.get(_usedItem.name) == null) {
					remove();
				}
				return true;
			} else {
				return false;
			}
		}

		override public function addChild(child : DisplayObject) : DisplayObject {
			return super.addChild(child);
		}
		
		public function remove():void {
			_usedItem = null;
			removeChild(_usedItemImg);
		}
	}
}
