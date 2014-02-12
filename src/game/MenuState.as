package game {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	
	public class MenuState extends BaseState 
	{
		public var MenuScreenMC : MovieClip;
		
		public function MenuState() 
		{
			super();
		}	
		
		override protected function initScreen():void 
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest("../embed/levels/menuPrincipal.swf"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, initScreenHandles, false, 0, true);
		}
		protected function initScreenHandles(e:Event):void 
		{
			MenuScreenMC = e.target.loader.content;
			screen = MenuScreenMC;
			screen.scaleX=1;
			screen.scaleY=1;
			stage.addEventListener (Event.RESIZE, resizeHandler);
			// initialize sizing
			resizeHandler (null);
			super.initScreen();
			_ce.sound.playSound("menu");
		}
		private function resizeHandler(event:Event):void { 
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight;
		
			 screen.height = sh;
			 screen.width = sw;
		}
		
		override protected function buttonClicked(event:MouseEvent):void 
		{
			var buttonName:String = event.target.name;
			
			if (buttonName == "jugar")
			{
				_ce.sound.stopSound("menu");
				mainClass.showGameState();
			}
		}
	}
}
