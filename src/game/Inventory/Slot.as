package game.Inventory {
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	/**
	 * @author Administrador
	 */
	public class Slot {
		public static function buildSlot(itemWidth : int, itemHeight : int, text : String) : Sprite {
			var slot : Sprite = new Sprite();
			slot.name = "slot";
			var slotBox : QuadBatch = makeBox(70, 80, 0, 0);
			slot.addChild(slotBox);

			var slotQuantityBox : QuadBatch = makeBox(30, 30, itemWidth - 13, itemHeight + 5, Color.WHITE);
			slot.addChild(slotQuantityBox);

			var slotText : TextField = new TextField(30, 30, text, "Arial", 18, Color.BLACK);
			slotText.x = itemWidth - 13;
			slotText.y = itemHeight + 5;
			slot.addChild(slotText);

			return slot;
		}

		private static function makeBox(width : int, height : int, x : int, y : int, plainColor : int = Color.GRAY, borderColor : int = Color.BLACK) : QuadBatch {
			var borderThickness : int = 3;
			// Crear batch
			var slot : QuadBatch = new QuadBatch();

			// Crear un color
			var center : Quad = new Quad(width, height, plainColor);

			// Crear bordes
			var left : Quad = new Quad(borderThickness, height, borderColor);
			var right : Quad = new Quad(borderThickness, height, borderColor);

			var top : Quad = new Quad(width, borderThickness, borderColor);
			var down : Quad = new Quad(width, borderThickness, borderColor);

			// placing elements (top and left already placed)
			right.x = width - borderThickness;
			down.y = height - borderThickness;

			// build box
			slot.addQuad(center);
			slot.addQuad(left);
			slot.addQuad(top);
			slot.addQuad(right);
			slot.addQuad(down);
			slot.x = x;
			slot.y = y;
			slot.name = "slot";

			return slot;
		}
	}
}
