package com.juego.basicos.components {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.trace.Trace;
	import flash.text.*;
	
	public class textFormats extends TextFormat {
		
		private var _fuenteElegida:TextFormat;
		
		public function textFormats(){
		}
		public function getFormat(format:Number) :TextFormat {
			
			switch(format) {
				case 1:
					var font = new disneySimple();
				    var newFormat:TextFormat = new TextFormat();
					newFormat.size = 17;
					newFormat.align = TextFormatAlign.CENTER;
					newFormat.font = font.fontName;
					_fuenteElegida = newFormat
				break
			}
			return _fuenteElegida;
		}
	}
	
}
