package com.juego.basicos
{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.juego.basicos.levels.lv1;
	import com.juego.basicos.Player;
	

	public class Level extends MovieClip
	{

		private var _stageRef:MovieClip;
		private var _actualLv:MovieClip;
		private var _jugador:Player;
		
		public function Level(stageRef:MovieClip)
		{   
			_stageRef = stageRef;
			_actualLv = new lv1(0,0);
			this.addChild(_actualLv);
		}
		
		public function getLv() :MovieClip {
			return _actualLv;
		}
		
		public function getlvMc() :MovieClip {
			return _actualLv.getlvMc();
		}
		
		public function getlvColisions():MovieClip {
			return _actualLv.getlvColisions();
		}
		
		public function iniLv(player:Player,niebla:MovieClip) {
			_jugador = player;
			_actualLv.setPlayer(_jugador);
			_actualLv.setObjects();
			_actualLv.setNiebla(niebla);
		}

		public function Update() : void 
		{
			_actualLv.Update();
		}
	}
	
}

