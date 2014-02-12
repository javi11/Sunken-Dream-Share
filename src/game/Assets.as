package game {
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * This class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author hsharma
	 * 
	 */
	public class Assets {
		/**
		 * Heroe
		 */
		[Embed(source="/../embed/caracters/PlayerSprite.xml", mimeType="application/octet-stream")]
		public static const heroConfig : Class;
		[Embed(source="/../embed/caracters/PlayerSprite.atf",mimeType="application/octet-stream" )]
		public static const hero : Class;
		[Embed(source="/../embed/caracters/Pirata1.xml", mimeType="application/octet-stream")]
		public static const pirata1Config : Class;
		[Embed(source="/../embed/caracters/Pirata1.atf",mimeType="application/octet-stream" )]
		public static const pirata1 : Class;		
		/**
		 * Objetos
		 */
		[Embed(source="/../embed/objects/objectSprites.xml", mimeType="application/octet-stream")]
		public static const objectsConfig : Class;
		[Embed(source="/../embed/objects/objectSprites.atf", mimeType="application/octet-stream")]
		public static const objects : Class;
		/**
		 * UI
		 */
		[Embed(source="/../embed/ui/ui.xml", mimeType="application/octet-stream")]
		public static const uiConfig : Class;
		[Embed(source="/../embed/ui/ui.atf",mimeType="application/octet-stream" )]
		public static const ui : Class;
		/**
		 * Weapons
		 */
		[Embed(source="/../embed/weapons/weapons.xml", mimeType="application/octet-stream")]
		public static const weaponsConfig : Class;
		[Embed(source="/../embed/weapons/weapons.atf",mimeType="application/octet-stream" )]
		public static const weapons : Class;
		/**
		 * Niveles
		 */
		// Nivel1
		[Embed(source="/../embed/levels/LevelA1.xml", mimeType="application/octet-stream")]
		public static const levelA1Xml : Class;
		[Embed(source="/../embed/levels/eventosLevelA1.xml", mimeType="application/octet-stream")]
		public static const levelA1EventsConfig : Class;
		[Embed(source="/../embed/levels/eventosLevelA1.atf", mimeType="application/octet-stream")]
		public static const levelA1Events : Class;
		
		/**
		 * Cache 
		 */
		private static var gameTextures : Dictionary = new Dictionary();
		private static var gameTextureConfig : Dictionary = new Dictionary();
		private static var gameTextureAtlas : Dictionary = new Dictionary();

		/**
		 * Retorna la configuracion de una textura
		 * 
		 * @param nombre del archivo de configuración
		 * @return configuración starling.
		 */
		public static function getConfig(name : String) : XML {
			if (gameTextureConfig[name] == undefined) {
				gameTextureConfig[name] = XML(new Assets[name]());
			}

			return gameTextureConfig[name];
		}

		/**
		 * Retorna la Textura
		 * 
		 * @param nombre de la textura
		 * @return una textura starling.
		 */
		public static function getTexture(name : String) : Texture {
			if (gameTextures[name] == undefined) {
				var bitArray : ByteArray = new Assets[name]();
				gameTextures[name] = Texture.fromAtfData(bitArray, 1, false);
			}

			return gameTextures[name];
		}

		/**
		 * Retorna el atlas
		 * 
		 * @param nombre del atlas
		 * @return configuración starling.
		 */
		public static function getAtlas(name : String) : TextureAtlas {
			if (gameTextureAtlas[name] == null) {
				var texture : Texture = getTexture(name);
				var xml : XML = XML(getConfig(name + "Config"));
				gameTextureAtlas[name] = new TextureAtlas(texture, xml);
			}

			return gameTextureAtlas[name];
		}
		

	}
}
