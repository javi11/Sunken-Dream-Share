package game.levels {
	
	import citrus.utils.AGameData;
	
	/**
	 * @author Aymeric
	 */
	public class ALevelManager extends AGameData {	
		public function ALevelManager():void {
			
			super();
			
			_levels = [[LevelA1, "../embed/levels/LevelA1.swf"]];
		}
		
		public function get levels():Array {
			return _levels;
		}
		
		override public function destroy():void {
			
			super.destroy();
		}
	}
}