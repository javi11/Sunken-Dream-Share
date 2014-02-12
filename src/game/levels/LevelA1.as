package game.levels {
	import flash.events.MouseEvent;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;

	import game.Assets;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.Player;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	/**
	 * @author Javier
	 */
	public class LevelA1 extends ALevels {
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		public var _status : int;
		private var _inventory : Inventory;
		protected var _hero : Player;

		public function LevelA1() : void {
			super();
		}

		override public function initialize() : void {
			super.initialize();
			var bitmap : Bitmap = new _MapAtlasPng();
			var texture : Texture = Texture.fromBitmap(bitmap);
			var xml : XML = XML(new _MapAtlasConfig());
			var sTextureAtlas : TextureAtlas = new TextureAtlas(texture, xml);

			ObjectMakerStarling.FromTiledMap(XML(new _Map()), sTextureAtlas);

			stage.color = 0x000066;
			_inventory = Inventory.getInstance();
			loadLvXml();
			loadCaractersTextures();
			if (getStatus() != UNLOCKED) {
				setStatus(LOCKED);
			}
			// Configurar Cámara
			camera.target = _hero;
			camera.allowZoom = true;
			camera.allowRotation = true;
			camera.enabled = true;
			camera.reset();
			_ce.sound.playSound("levelA1Loop");
		}
	

		private function loadLvXml() : void {
			var levelXmL : XML = Assets.getConfig("levelA1Xml");
			var i : int = 0;
			// Items
			for each (var item : XML in levelXmL['items']['*']) {
				var gameObject : GameObject = null;
				if (item.@position == "gameobject") {
					gameObject = new GameObject(xmlToDictionary(item));
					_inventory.add(gameObject);
				} else if (item.@position == "hidenobject") {
					gameObject = new GameObject(xmlToDictionary(item));
					_inventory.add(gameObject);
					_inventory.status(gameObject.get("nameObject"), LOCKED);
				}
				i++;
			}
		}

		private function xmlToDictionary(item : XML) : Dictionary {
			var tempProperties : Dictionary = new Dictionary();
			for each (var property : XML in item.children()) {
				tempProperties[property.name()] = property;
			}
			return tempProperties;
		}

		private function loadCaractersTextures() : void {
			// Héroe
			var animation : AnimationSequence = new AnimationSequence(Assets.getAtlas('hero'), ["walk", "duck", "idle", "jump", "hurt", "talk", "climbUp", "climbIdle","cocoAttack","hit"], "idle");
			_hero = getObjectByName("Player") as Player;
			_hero.view = animation;
			_hero.iniPlayer();
			_hero.setHeroCanClimbLadders(true);

			StarlingArt.setLoopAnimations(["idle", "talk","climbUp","movinPlatform"]);
		}

		public function setStatus(status : int) : void {
			_status = status;
		}

		public function getStatus() : int {
			return _status;
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
			// trace("/ heroX="+_hero.x+"/ heroY="+ _hero.y);
		}

		// Cargar Nivel
		[Embed(source="/../embed/levels/levelA1.tmx", mimeType="application/octet-stream")]
		private var _Map : Class;
		[Embed(source="/../embed/levels/TilesLA1.png")]
		private var _MapAtlasPng : Class;
		[Embed(source="/../embed/levels/TilesLA1.xml" , mimeType="application/octet-stream")]
		private var _MapAtlasConfig : Class;
	}
}