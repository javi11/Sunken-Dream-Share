package game.levels {
	import citrus.objects.platformer.box2d.Sensor;

	/**
	 * @author Administrador
	 */
	public class Stairs extends Sensor {
		public function Stairs(name : String, params : Object = null) : void {
			super(name, params);
			isLadder = true;
		}
	}
}
