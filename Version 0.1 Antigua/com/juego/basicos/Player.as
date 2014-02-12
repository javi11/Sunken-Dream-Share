package com.juego.basicos {

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.trace.Trace;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	
	import com.juego.basicos.components.textFormats;

	public class Player extends MovieClip
	{
		//VARIABLES Generales
		private var _stageRef:MovieClip;
		private var _parentClip:MovieClip;
		private var _vCam:MovieClip;
		private var _nCocos:Number = 5;
		private var _lv:MovieClip;
		private var _inventario:Array = new Array();
		private var _objetoEnUso:MovieClip;
		private var _cocos:TextField;
		private var _inventarioMc = new Inventario();
		
		//VARIABLES Dynamicas
		private var _velLateral:Number = 1.5;
		private var _friccion:Number = 0.7;
		private var _friccionAire:Number = .8;
		private var _gravedad:Number = -2;
		private var _tiempoSalto:Number = 4;
		private var _salto:Number = 6.25;
		private var _velMaxima:Number = 7;
		private var _dx:Number;
		private var _dy:Number;
		private var _saltando:Boolean;
		private var _empezoSalto:Number;
		private var _direccion:Number;
		private var _caida:Number = 25;
		private var _perfectColision:Boolean;
		
		//Porpiedades Personaje
		private var _mitadAltura:Number;
		private var _mitadAnxura:Number;
		private var _brillo:Number = 0;
		
		//Disparar
		private var _fireTimer:Timer;
		private var _canFire:Boolean = true;
		
		//Controles
		public var leftKEY:Boolean;
		public var upKEY:Boolean;
		public var downKEY:Boolean;
		public var rightKEY:Boolean;
		public var spaceKEY:Boolean;
		public var ctrlKEY:Boolean;
		public var pauseKEY:Boolean;
			

		public function Player(parentClip:MovieClip,stageRef:MovieClip,lv:MovieClip,vCam:MovieClip) : void {
			_dx = 0;
			_dy = 0;
			_saltando = false;
			_empezoSalto=0;
			_objetoEnUso = null;
			_stageRef = stageRef;
			_vCam = vCam;
			_parentClip = parentClip;
			_direccion = +1;
			_lv = lv;
			_perfectColision = false;
			
			//Configurar disparar Cocos
			var disney:textFormats = new textFormats();
			_cocos=new TextField();
			_cocos.defaultTextFormat = disney.getFormat(1);
			_cocos.x =-55;
			_cocos.y =-14;
			_cocos.text= ""+_nCocos+"";
			_stageRef.getCocoDisplay().addChild(_cocos);
			_fireTimer = new Timer(1100, 1);
			_fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);
			/* EVENTO MOXILA */
			_inventarioMc.visible = false;
			_vCam.addChild(_inventarioMc);
			_vCam.moxila.addEventListener("click", abrirInventario);
			
		}
		public function setPerfectColision(perfectColision) {
			_perfectColision = perfectColision;
		}
		
		private function comprovarColisiones() : void {
			//Colisiones
			/* PRUEBA
			for (var i:uint = 0; i < _lv.numChildren; i++){
				var block:MovieClip = _lv.getChildAt(i) as MovieClip;
				if(leftKEY) {
					if(this.hitTestObject(block)) {
						this.x+=1;
						_dx *= -1;
					}
				}
				if(rightKEY) {
					if(this.hitTestObject(block)) {
						this.x -=1;
						_dx *= -1;
					}
				}
				if(upKEY) {
					if(this.hitTestObject(block)) {
						this.y+=1;
						_dy = 0;
					}
				}
				if(this.y >= block.y) {
					if(this.hitTestObject(block)) {
						while (this.hitTestObject(block)) {
							this.y-=1;
							_saltando = false;
							_dy = 0;
						}
					}
				}
			}
			PREUBA*/
			//pega arriba
			for (var i:uint = 0; i < _lv.numChildren; i++){
				var block:MovieClip = _lv.getChildAt(i) as MovieClip;
				if(this.hitTestObject(block)) {
				//pega arriba
					while(block.hitTestPoint(this.x,this.y-_mitadAltura,true)){
						this.y+=1;
						_dy = 0;
					}
				//pega abajo
					while(block.hitTestPoint(this.x,1+this.y+_mitadAltura,true)){
						this.y-=1;
						_saltando = false;
						_dy = 0;
					}
				//pega izq	
					while(block.hitTestPoint(this.x-_mitadAnxura,this.y,true)){
						this.x+=1;
						_dx=0;
					}
				if(_perfectColision) {
				//pega izq	
					while(block.hitTestPoint(this.x-_mitadAnxura,1+this.y+_mitadAltura,true)){
						this.x+=1;
						_dx=0;
					}
					//pega der
					while(block.hitTestPoint(this.x+_mitadAnxura,1+this.y+_mitadAltura,true)){
						this.x -=1;
						_dx=0;
					}
				}
				//pega der
					while(block.hitTestPoint(this.x+_mitadAnxura,this.y,true)){
						this.x -=1;
						_dx=0;
					}

				}
			}
		}
		
		public function Update() : void {
			_mitadAltura = this.height/2;
			_mitadAnxura = this.width/2;			
			this.movimientosKEY();
			if(_dx>_velMaxima){
				_dx=_velMaxima;
			}else if(_dx<-_velMaxima){
					_dx=-_velMaxima;
			}
			this.x +=_dx;
			_dx *= _friccion;
			this.y +=_dy;
			
			if(!_lv.hitTestPoint(this.x,1+this.y+_mitadAltura,true)){
				_saltando = true;
			}
			
			if(_saltando){
				_dy-=_gravedad;
				if(_dy>_caida){
					_dy = _caida;
				}
			}
			this.comprovarColisiones();
			
			_vCam.x +=(this.x-_vCam.x)/12;
			_vCam.y +=(this.y-_vCam.y)/12;
			_vCam.camControl();
			
				
		}
		
		private function movimientosKEY() : void{
				//keypresses
			if (ctrlKEY) {
				animaciones("dispara");
				fireCoco();
			}
			if(spaceKEY) {
				animaciones("cabezazo");
			}
			if(upKEY && _saltando==false) {
				animaciones("normal");
				animaciones("salto");
				salta();
			} else if(upKEY &&_empezoSalto>0 ){
				_dy-=_salto;
			}
			if(downKEY) {
				if(upKEY) {
					animaciones("salto");
				} else if(!leftKEY && !rightKEY) {
					animaciones("agaxarse");
				}
			}
			if(leftKEY && !spaceKEY && !ctrlKEY) {
				if(upKEY) {
					animaciones("salto");
				} else {
					animaciones("caminar");
				}
				_dx -= _velLateral;
				this.scaleX = -1;
				_direccion = -1;
			} else if(rightKEY && !spaceKEY && !ctrlKEY) {
				if(upKEY) {
					animaciones("salto");
				} else {
					animaciones("caminar");
				}
				_dx += _velLateral;
				this.scaleX = +1;
				_direccion = +1;
			}         
			if(!rightKEY && !leftKEY && !downKEY && !upKEY && !spaceKEY && !ctrlKEY) {
				animaciones("normal");
			}
			_empezoSalto--;		
		}
		
		private function salta() : void{
			_friccion = _friccionAire;
			_dy -= _salto;
			_saltando = true;
			_empezoSalto= _tiempoSalto;
		}
		
		private function fireCoco() : void
		{
			if (_canFire && _nCocos != 0)
			{
				_nCocos--;
				_stageRef.addChild(new Coco(this, this.x, this.y,_direccion,_gravedad,_lv));
				_cocos.text= ""+_nCocos+"";
				_canFire = false;
				_fireTimer.start();
			}
			
		}
		
		private function fireTimerHandler(e:TimerEvent) : void
		{
			//timer ran, we can fire again.
			_canFire = true;
		}
		
		private function animaciones(goto:String) {
			_movimientos.gotoAndStop(goto);
		}
		
		/*
		*anadirInventario
		*	Añade un objeto al inventario.
		*	objeto: objeto a añadir.
		*/
		public function anadirInventario(objeto:MovieClip) : void{
			_inventario.push(objeto);
		}
		
		public function eliminarDeInventario(objeto:MovieClip) : void{
			var contador:Number = _inventario.length;
			var i:Number = 0;
			var eliminado = false;
			while( i<contador && eliminado == false) {
				if(objeto == _inventario[i]) {
					_inventario.splice(i);
					eliminado = true;
				}
			}
		}
		
		/*
		*mostrarItems
		*	Muestra los items de la moxila
		*
		*/
		public function abrirInventario(e:Event) : void {
			if(_inventarioMc.visible) {
				_inventarioMc.visible = false;
			} else {
				_inventarioMc.visible = true;
			}
		}
		
		public function setBrillo(offset:Number) : void {
			_brillo += offset;
			var c:ColorTransform = new ColorTransform();
			c.redOffset = c.greenOffset = c.blueOffset = _brillo;
			this.transform.colorTransform = c;
		}
		
		public function getBrillo() :Number {
			return _brillo;
		}
	}

}