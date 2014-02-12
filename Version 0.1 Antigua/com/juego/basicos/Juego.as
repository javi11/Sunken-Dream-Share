//package...
package com.juego.basicos
{
	//imports necesesarios 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;	
	import flash.events.KeyboardEvent;
	import flash.display.StageScaleMode;
	import flash.trace.Trace;
	
	//Clase Juego
	public class Juego extends MovieClip
	{
		private var pausa:Boolean = false;	
		private var player1:Player;
		private var lv:Level;
		
		public function Juego() 
		{
		  addEventListener(Event.ADDED_TO_STAGE, init);
		}
		//Constructor
		private function init(e:Event):void
        {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			_vCam._nieblaGuerra.visible = false;
			//Create level
			lv = new Level(_tablero);
			lv.x = 0;
			lv.y = 0;
			//Crear el player
			player1 = new Player(_tablero,this,lv.getlvColisions(),_vCam);
			//Añadirlo a la escena
			player1.x = -600;
			player1.y = -100;
			//Añadir el player al lv
			lv.iniLv(player1,_vCam._nieblaGuerra);
			
			_tablero.addChild(lv);
			_tablero.addChild(player1);


			player1.addEventListener( Event.ENTER_FRAME, gameLoop, false, 0, true );
			
			//Controles
			if (stage != null)
    		{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			}
		}
	
	    public function setPausa() {
			if(this.pausa == true) {
				this.pausa = false;
			} else {
				this.pausa = true;
			}
		}
		
		private function key_down(event:KeyboardEvent){
			
			if(event.keyCode == 37){
				player1.leftKEY = true;
			}
			if(event.keyCode == 38){
				player1.upKEY = true;
			}
			if(event.keyCode == 39){
				player1.rightKEY = true;
			}
			if(event.keyCode == 40){
				player1.downKEY = true;
			}
			if(event.keyCode == 32){
				player1.spaceKEY = true;
			}
			if(event.keyCode == 17) {
				player1.ctrlKEY = true;
			}
			if(event.keyCode == 80) {
				player1.pauseKEY = true;
			}		
		}
		
		private function key_up(event:KeyboardEvent){
			if(event.keyCode == 37){
				player1.leftKEY = false;
			}
			if(event.keyCode == 38){
				player1.upKEY = false;
			}
			if(event.keyCode == 39){
				player1.rightKEY = false;
			}
			if(event.keyCode == 40){
				player1.downKEY = false;
			}
			if(event.keyCode == 32){
				player1.spaceKEY = false;
			}
			if(event.keyCode == 17) {
				player1.ctrlKEY = false;
			}
			if(event.keyCode == 80) {
				player1.pauseKEY = false;
			}
		}
		
		public function gameLoop (e:Event) : void {
			player1.Update();
			lv.Update();
		}
		
		public function getCocoDisplay() :MovieClip{
			return _vCam._cocosDisplay._nCocosDisplay;
		}
	}
	
}