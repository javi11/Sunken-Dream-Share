package game.levels {
	import game.Assets;
	import citrus.objects.CitrusSprite;
	/**
	 * @author Javier
	 */
	public class LevelEvents extends CitrusSprite {
		private var _key : String;

		public function LevelEvents(name:String,params:Object = null) : void {
			super(name,params);
			view = Assets.getAtlas('levelA'+params['lv']+'Events').getTexture(params['texture']);
			touchable = true;
		}

		public function isTheKey(key : String) : Boolean {
			if (key == _key) {
				return true;
			} else {
				return false;
			}
		}

	}
}
