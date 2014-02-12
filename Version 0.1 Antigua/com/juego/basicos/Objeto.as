package com.juego.basicos
{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.trace.Trace;
	import flash.utils.getDefinitionByName;
	import com.juego.basicos.Player;
	
	public class Objeto extends MovieClip
	{
		
		private var _level:MovieClip;
		private var _jugador:Player;
		private var _objeto:MovieClip;
		private var _posCounter:Number;
		private var _direccionObjeto:Number;
		private var _cojido:Boolean;
		

		public function Objeto(level:MovieClip,posX:Number,posY:Number,jugador:Player,objeto:String)
		{
			_level = level;
			_jugador =  jugador;
			this.x = posX;
			this.y = posY;
			addMovieFromLibrary(objeto);
			_posCounter = 0;
			_direccionObjeto = -1;
			_cojido = false;
		}
		
		private function removeSelf() : void
		{
			_objeto.visible = false;
			_cojido = true;
		}
		
		private function addMovieFromLibrary(mcIName:String){
			var tMC:Class = getDefinitionByName(mcIName) as Class;
			_objeto = new tMC();
			_objeto.x = this.x;
			_objeto.y = this.y;
			_objeto.width = 41;
			_objeto.height = 30;
			_level.addChild(_objeto);
		}
		
		public function Update() {
			if(!_cojido) {
				_objeto.y += 1*_direccionObjeto;
				_posCounter += 1*_direccionObjeto;
				if(_posCounter == -20) {
					_direccionObjeto = +1;
				} else if(_posCounter == 0) {
					_direccionObjeto = -1;
				}
				if(_objeto.hitTestObject(_jugador)){
					_jugador.anadirInventario(_objeto);
					removeSelf();
				}
			}
		}

		
	}
	
}