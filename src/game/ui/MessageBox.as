package game.ui {
	import citrus.objects.CitrusSprite;

	import feathers.controls.text.TextFieldTextRenderer;

	import game.FontAssets;

	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.utils.Color;

	import flash.text.Font;
	import flash.text.TextFormat;

	/**
	 * @author Javier
	 */
	public class MessageBox extends CitrusSprite {
		private var _textField : TextFieldTextRenderer;

		function MessageBox(name : String, params : Object = null) : void {
			super(name, params);
		}

		public function set(x : int, y : int, text : String, fontColor : uint = Color.OLIVE, fontSize : int = 16) : void {
			if (_textField) Sprite(view).removeChild(_textField);
			this.x = x;
			this.y = y;
			var bf : BlurFilter = BlurFilter.createGlow(Color.BLACK, 5, 1.0);
			var font : Font = new FontAssets.MonkeyIslandFont();
			var defaultTextFormat : TextFormat = new TextFormat(font.fontName, fontSize, fontColor);
			defaultTextFormat.align = "center";
			defaultTextFormat.letterSpacing = 3;
			_textField = new TextFieldTextRenderer();
			_textField.width = 400;
			_textField.height = 100;
			_textField.textFormat = defaultTextFormat;
			_textField.text = text;
			_textField.embedFonts = true;
			_textField.maxWidth = 400;
			_textField.wordWrap = true;
			_textField.filter = bf;

			view = new Sprite();
			Sprite(view).addChild(_textField);
			group = 5;
		}

		public function updateCord(x : int, y : int) : void {
			this.x = x;
			this.y = y;
		}
	}
}
