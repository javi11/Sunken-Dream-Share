package game.Inventory {
	import citrus.core.CitrusEngine;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;

	import flash.utils.Dictionary;

	public class Inventory extends Sprite {
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		public var slots : Dictionary = new Dictionary();
		private static var _instance : Inventory;
		public var inventoryView : Sprite;
		private var _inventoryItems : Sprite;
		private var _inventorySlots : Sprite;
		private var _inventoryOptions : Sprite;
		private var _paddingX : int = 100;
		private	var _paddingY : int = 140;
		public var isVisible : Boolean;
		private var _ce : CitrusEngine;

		public function Inventory() {
			inventoryView = new Sprite();
			name = "inventory";
		}

		public static function getInstance() : Inventory {
			if (!_instance) {
				_instance = new Inventory();
			}
			return _instance;
		}

		public function clear() : void {
			slots = new Dictionary();
		}

		public function add(gameObject : GameObject) : void {
			if (!slots[gameObject.name]) {
				slots[gameObject.name] = gameObject;
			} else {
				slots[gameObject.name]['set']('quantity', int(slots[gameObject.name]['get']('quantity')) + 1);
			}
		}

		public function set(gameObject : GameObject, num : int) : void {
			slots[gameObject.name]['set']('quantity', num);
		}

		public function remove(gameObject : GameObject) : void {
			if (slots[gameObject.name]) {
				slots[gameObject.name]['set']('quantity', int(slots[gameObject.name]['get']('quantity')) - 1);
				if (int(slots[gameObject.name]['get']('quantity')) == 0) {
					delete slots[gameObject.name];
				}
			}
		}

		public function get(name : String) : GameObject {
			return  slots[name] as GameObject;
		}

		public function status(name : String, status : int) : Boolean {
			if (slots[name]) {
				return  slots[name]['setStatus'](status);
			}
			return false;
		}

		public function showInventory(Texture : TextureAtlas) : void {
			isVisible = true;
			inventoryView.addChild(new Image(Texture.getTexture("inventario")));
			inventoryView.width = 800;
			inventoryView.height = 500;
			inventoryView.name = "inventory";
			_inventoryItems = new Sprite();
			_inventorySlots = new Sprite();
			_inventoryOptions = new Sprite();
			addChild(inventoryView);

			var lvObjects : Button = new Button();
			lvObjects.label = "Objetos del Nivel";
			lvObjects.x = _paddingX - 14;
			lvObjects.y = _paddingY - 70;
			lvObjects.name = "key";
			lvObjects.touchable = true;
			lvObjects.useHandCursor = true;
			lvObjects.addEventListener(Event.TRIGGERED, categoryHandler);
			lvObjects.width = 170;
			lvObjects.height = 40;
			lvObjects.addChild(new  TextField(200, 50, "Objetos del Nivel", "Arial", 18, Color.BLACK, true));
			_inventoryOptions.addChild(lvObjects);

			var weapons : Button = new Button();
			weapons.label = "Armas";
			weapons.name = "weapons";
			weapons.x = _paddingX + 285;
			weapons.y = _paddingY - 70;
			weapons.touchable = true;
			weapons.useHandCursor = true;
			weapons.width = 170;
			weapons.height = 40;
			weapons.addEventListener(Event.TRIGGERED, categoryHandler);
			weapons.addChild(new  TextField(200, 50, "Armas", "Arial", 18, Color.BLACK, true));
			_inventoryOptions.addChild(weapons);

			var otherObjects : Button = new Button();
			otherObjects.label = "Otros Objetos";
			otherObjects.name = "items";
			otherObjects.x = _paddingX + 455;
			otherObjects.y = _paddingY - 70;
			otherObjects.touchable = true;
			otherObjects.useHandCursor = true;
			otherObjects.width = 170;
			otherObjects.height = 40;
			otherObjects.addEventListener(Event.TRIGGERED, categoryHandler);
			otherObjects.addChild(new  TextField(200, 50, "Otros Objetos", "Arial", 18, Color.BLACK, true));
			_inventoryOptions.addChild(otherObjects);

			makeInventoryItems("key");
			addChild(_inventoryOptions);
			addChild(_inventorySlots);
			addChild(_inventoryItems);
		}

		public function removeInventory() : void {
			if (inventoryView) removeChild(inventoryView);
			var i : int = 0;
			while (i < _inventoryItems.numChildren) {
				_inventoryItems.getChildAt(i).alpha = 1;
				i++;
			}
			if (_inventoryItems) removeChild(_inventoryItems);
			if (_inventorySlots) removeChild(_inventorySlots);
			if (_inventoryOptions) removeChild(_inventoryOptions);
			isVisible = false;
		}

		public function hideInventory() : void {
			removeChild(inventoryView);
			removeChild(_inventoryOptions);
			removeChild(_inventorySlots);
			var i : int = 0;
			while (i < _inventoryItems.numChildren) {
				_inventoryItems.getChildAt(i).alpha = 0;
				i++;
			}
			_ce = CitrusEngine.getInstance();
			_ce.playing = true;
			isVisible = false;
		}

		public function categoryHandler(e : Event) : void {
			var target : Button = e.currentTarget as Button;
			switch(target.name) {
				case 'key':
					makeInventoryItems("key");
					break;
				case 'items':
					makeInventoryItems("item");
					break;
				case 'weapons':
					makeInventoryItems("weapon");
					break;
			}
		}

		public function makeInventoryItems(type : String) : void {
			if (!isEmptyInventory()) {
				removeAllChildren(_inventoryItems);
				removeAllChildren(_inventorySlots);
				var row : int = 0;
				var col : int = 0;
				var marginX : int = 20;
				for (var key : Object in slots) {
					var item : GameObject = slots[key];
					if (item.get("type") == type && item.getStatus() == UNLOCKED) {
						item.x = (item.width + marginX) * col + _paddingX;
						if (col == 17) {
							row += 1;
							col = 0;
						}
						item.y = (item.height + marginX) * row + _paddingY;
						col++;
						var slot : Sprite = Slot.buildSlot(item.width, item.height, item.get("quantity"));
						slot.x = item.x;
						slot.y = item.y;
						_inventorySlots.addChild(slot);
						_inventoryItems.addChild(item);
					}
				}
			}
		}

		private function removeAllChildren(ui : Sprite) : void {
			for (var i : int = ui.numChildren - 1; i >= 0; i--) {
				ui.removeChildAt(i);
			}
		}

		public function isEmptyInventory() : Boolean {
			for each (var obj : Object in slots) {
				if (obj != null) {
					return false;
				}
			}
			return true;
		}
	}
}
