package game {
	import citrus.objects.platformer.box2d.Crate;

	import flash.utils.Dictionary;

	/**
	 * @author Administrador
	 */
	public class PhysicBox extends Crate {
		public var peObject : String = "";
		public var ptm_ratio : Number = 32;
		public var dict : Dictionary;

		public function PhysicBox(name : String, params : Object = null) {
			super(name, params);
			peObject = name;
			view = Assets.getAtlas('objects').getTexture(params['texture']);
		}

		override protected function defineFixture() : void {
			super.defineFixture();
			_fixtureDef.density = _getDensity();
			_fixtureDef.friction = _getFriction();
			_fixtureDef.restitution = _getRestitution();
		}

		protected function _getDensity() : Number {
			switch (peObject) {
				case "barril":
					return 1;
			}

			return 1;
		}

		protected function _getFriction() : Number {
			switch (peObject) {
				case "barril":
					return 0.6;
			}

			return 0.6;
		}

		protected function _getRestitution() : Number {
			switch (peObject) {
				case "barril":
					return 0.3;
			}

			return 0.3;
		}
	}
}
