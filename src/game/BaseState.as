package game {
	import citrus.core.State;
	import citrus.core.CitrusEngine;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.Basic;
	import game.Main;
	
	public class BaseState extends State
	{
		protected var mainClass:Main;
		
		protected var screen:MovieClip;
		
		public function BaseState()
		{
			mainClass = CitrusEngine.getInstance() as Main;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initScreen();
			
		}
		
		
		protected function initScreen():void
		{
			if (screen == null)
			{
				throw new Error("ERROR: You forgot to instantiate new screen object :)");
			}
			
			addChild(screen);
			
			Basic.registerMouseEvent(screen, buttonClicked, buttonOver, buttonOut);
		}
		
		protected function buttonClicked(event:MouseEvent):void
		{
			//tiene que definirse en las clases hijo de esta
		}
		
		protected function buttonOver(event:MouseEvent):void
		{
			var button:MovieClip = event.target as MovieClip;
			var buttonName:String = event.target.name;
			
			if (buttonName == "jugar")
			{
				_ce.sound.playSound("MenuSelection");
				button.gotoAndStop(2);
			}
		}
		
		protected function buttonOut(event:MouseEvent):void
		{
			var button:MovieClip = event.target as MovieClip;
			var buttonName:String = event.target.name;
			
			if (buttonName == "jugar")
			{
				_ce.sound.stopSound("MenuSelection");
				button.gotoAndStop(1);
			}
		}
		
		override public function destroy():void
		{
			Basic.unregisterMouseEvent(screen, buttonClicked, buttonOver, buttonOut);
			
			removeChild(screen);
			screen = null;
			
			mainClass = null;
			
			super.destroy();
		}
	}
}
