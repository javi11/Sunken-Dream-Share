package game {
	import citrus.sounds.CitrusSoundGroup;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.LevelManager;

	import game.levels.ALevels;

	import flash.events.Event;
	import flash.system.ApplicationDomain;

	[SWF(frameRate="50" ,width = "900", height = "417")]
	/**
	 * @author Javier
	 */
	public class Main extends StarlingCitrusEngine {
		public static const MENU_STATE:String = "menu_state";

		
		public function Main() {
			gameData = new ALevelManager();
			iniSounds();
		}

		override protected function handleAddedToStage(e : Event) : void {
			super.handleAddedToStage(e);
			setUpStarling(true, 1, null, "baseline");
			starling.simulateMultitouch = true;
			changeState(MENU_STATE);
		}
		
		public function changeState(newState:String):void
		{
			switch(newState)
			{
				case MENU_STATE:
					state = new MenuState();
					break;
					
			}
		}
		
		public function showGameState():void
		{
			levelManager = new LevelManager(ALevels);
			levelManager.applicationDomain = ApplicationDomain.currentDomain;
			levelManager.onLevelChanged.add(_onLevelChanged);
			levelManager.levels = gameData['levels'];
			levelManager.gotoLevel();
		}
		
		private function iniSounds(): void {
			sound.addSound("Collect", {sound:"../embed/sounds/collect.mp3",group:CitrusSoundGroup.SFX});
			sound.addSound("Hurt", {sound:"../embed/sounds/hurt.mp3",group:CitrusSoundGroup.SFX});
			sound.addSound("Jump", {sound:"../embed/sounds/jump.mp3",group:CitrusSoundGroup.SFX});
			sound.addSound("Hit", {sound:"../embed/sounds/punch.mp3",group:CitrusSoundGroup.SFX});
			sound.addSound("MenuSelection", {sound:"../embed/sounds/beep2.mp3",group:CitrusSoundGroup.SFX,volume:0.5});
			sound.addSound("CocoCannon", {sound:"../embed/sounds/cococannon.mp3",group:CitrusSoundGroup.SFX});
			sound.addSound("Walk", { sound:"../embed/sounds/walk.mp3",loops: -1, volume:1, group:CitrusSoundGroup.SFX } );
			sound.addSound("levelA1Loop", {sound:"../embed/sounds/levelA1.mp3",loops:-1,group:CitrusSoundGroup.BGM});
			sound.addSound("menu", {sound:"../embed/sounds/menu.mp3",loops:-1,group:CitrusSoundGroup.BGM,volume:0.08});
		}

		private function _onLevelChanged(lvl : ALevels) : void {
			state = lvl;

			// lvl.lvlEnded.add(_nextLevel);
			// lvl.restartLevel.add(_restartLevel);
		}
		/*	
		private function _restartLevel():void {
		state = levelManager.currentLevel as IState;
		}
		
		private function _nextLevel():void {
			
		levelManager.nextLevel();
		}
		 */
	}
}