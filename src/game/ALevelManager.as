package game {
	import citrus.utils.AGameData;

	import game.levels.*;

	/**
	 * @author Javier
	 */
	public class ALevelManager extends AGameData {
		public var playerX : Number;
		public var playerY : Number;

		public function ALevelManager() : void {
			super();

			_levels = [LevelA1];
		}

		public function get levels() : Array {
			return _levels;
		}

		override public function destroy() : void {
			super.destroy();
		}
	}
}