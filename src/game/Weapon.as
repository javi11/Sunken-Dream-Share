package game {
	import flash.utils.setTimeout;
	import citrus.core.CitrusEngine;
	import citrus.objects.Box2DPhysicsObject;

	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.weapons.*;

	import flash.utils.getDefinitionByName;

	public class Weapon {
		private var _ce : CitrusEngine;
		private var _defaultWeapon : String = "Puño";
		private var _weapon : GameObject;
		private var _vel : Array;
		private var inventory : Inventory;
		private static var _instance : Weapon;
		public var distance:String;
		protected var _longAttackTimeout:uint = 0;

		public function Weapon() {
			inventory = Inventory.getInstance();
			selectWeapon(_defaultWeapon);
			_ce = CitrusEngine.getInstance();
			var weapons : Array = [Cannon];
		}

		public static function getInstance() : Weapon {
			if (!_instance) {
				_instance = new Weapon();
			}
			return _instance;
		}

		public function setBullets(num : int) : void {
			_weapon.set("quantity", num);
			updateInventory();
		}

		public function addBullet() : void {
			_weapon.set("quantity", _weapon.get("quantity") + 1);
			updateInventory();
		}
		
		public function getBullets() : int {
			return _weapon.get("quantity");
		}

		public function updateInventory() : void {
			inventory.set(_weapon, _weapon.get("quantity"));
		}

		public function selectWeapon(name : String) : void {
			if (inventory.get(name) == null) {
				_weapon.set("velX", 10);
				_weapon.set("velY", 10);
				_weapon.name = "Cannon";
			} else {
				_weapon = inventory.get(name);
				distance = _weapon.get("distance");
			}
		}

		public function shoot() : void {
			if (_weapon.get("distance") == "large" && _weapon.get("quantity") != 0 ) {
				_longAttackTimeout = setTimeout(rangeShoot, 500);
			}
		}
		
		public function rangeShoot():void {
			var player1 : Player = _ce.state.getObjectByName("Player") as Player;
			var posX: Number;
			if (player1.inverted) {
					_vel = [-_weapon.get("velX"), -_weapon.get("velY")];
					posX = player1.x - player1.width;
				} else {
					_vel = [+_weapon.get("velX"), -_weapon.get("velY")];
					posX = player1.x + player1.width;
				}
				var weaponBullet : Class = getDefinitionByName("game.weapons." + _weapon.name) as Class;
				var bullet : Box2DPhysicsObject;
				bullet = new weaponBullet("bullet" + _weapon.get("quantity"), posX, (player1.y - player1.height / 2)+36,"coco",_weapon.get("damage"));
				_weapon.set("quantity", _weapon.get("quantity") - 1);
				updateInventory();
				_ce.state.add(bullet);
				bullet.velocity = _vel;
				
		}
		
		public function getDamage():int {
			if(_weapon.get("distance") == "short") {
				return _weapon.get("damage");
			} else {
				return 0;
			}
		}
	}
}