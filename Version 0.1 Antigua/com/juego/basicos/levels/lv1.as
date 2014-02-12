package com.juego.basicos.levels {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.trace.Trace;
	import com.juego.basicos.Objeto;
	import com.juego.basicos.Player;
	
	public class lv1 extends MovieClip {
		
		private var _jugador:Player;
		private var _diario:Objeto;
		private var _llave:Objeto;
		private var _palanca:Objeto;
		private var _telaArana:Objeto;
		private var _niebla:MovieClip;
		
		public function lv1(posX:Number,posY:Number) {
			this.x = posX;
			this.y = posY;
			
		}
		public function setObjects() {
			diario;
			_diario = new Objeto(_lvObjects,-550,470,_jugador,"diario");
			addChild(_diario);
			llave;
			_llave = new Objeto(_lvObjects,320,-475,_jugador,"llave");
			addChild(_llave);			
		}
		public function getlvMc() :MovieClip {
			return _lvObjects;
		}
		public function getlvColisions() :MovieClip {
			return _lvObjects._nivelxoque;
		}
		public function Update() {
			//Zonas de Brillo y Oscuridad
			if((_lvObjects.luz1.hitTestObject(_jugador) || _lvObjects.luz2.hitTestObject(_jugador) || _lvObjects.luz3.hitTestObject(_jugador)) && _jugador.getBrillo()!= 0) {
				_jugador.setBrillo(+5);
				if(_jugador.getBrillo() == -75) {
					_niebla.gotoAndStop("nieblaLuz");
				}
			} else if(_lvObjects._nivelTrasparente.hitTestObject(_jugador)) {
				if(_jugador.getBrillo() == 0) {
					_lvObjects._nivelTrasparente.visible = false;
					_niebla.visible = true;
					_niebla.gotoAndStop("niebla");
				}
				if(_jugador.getBrillo()!= -80)  {
					_jugador.setBrillo(-5);
				}
			} else if(_lvObjects._nivelTrasparente.visible == false) {
				_lvObjects._nivelTrasparente.visible = true;
				_niebla.visible = false;
			}else if(_jugador.getBrillo()!= 0)  {
				_jugador.setBrillo(+5);
			}
			updateObjects();
		}
		public function setPlayer(player:Player) {
			_jugador = player;
		}
		public function setNiebla(niebla:MovieClip){
			_niebla = niebla;
		}
		
		private function updateObjects() {
			_diario.Update();
			_llave.Update();
			
		}
	}
	
}
