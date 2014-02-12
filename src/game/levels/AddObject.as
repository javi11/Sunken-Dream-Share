package game.levels {
	import game.Player;

	import Box2D.Common.Math.b2Vec2;

	import citrus.core.CitrusEngine;

	import game.Assets;

	import citrus.core.CitrusObject;

	/**
	 * @author Administrador
	 */
	public class AddObject {
		private static var _citrusObject : CitrusObject;

		public static function get(params : Object) : CitrusObject {
			var ce : CitrusEngine = CitrusEngine.getInstance();
			var hero : Player = ce.state.getObjectByName("Player") as Player;

			switch(params['object']) {
				case 'rope':
					_citrusObject = new Rope("rope", {group:2, anchor:ce.state.getObjectByName(params['objectAnchor']), ropeLength:190, widthSegment:15, numSegments:20, segmentTexture:Assets.getAtlas("objects").getTexture("segmentoCuerda"), useTexture:true, heroAnchorOffset:new b2Vec2(0, -((hero.height + 5) / 2))});
					break;
			}

			return _citrusObject;
		}
	}
}
