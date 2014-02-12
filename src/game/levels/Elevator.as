package game.levels {
	import citrus.view.starlingview.AnimationSequence;
	import game.Assets;
	import citrus.objects.platformer.box2d.MovingPlatform;
	/**
	 * @author Administrador
	 */
	public class Elevator extends MovingPlatform{
		private var _message : String;
		public function Elevator(name:String,params:Object = null):void {
			super(name,params);
			var animationSequence:AnimationSequence = new AnimationSequence(Assets.getAtlas('levelA' + params['lv'] + 'Events'), [params['texture']], params['texture'],30,true);
			view = animationSequence;
			_message = params['message'];
			touchable = true;
		}
		public function getMessage() : String {
			return _message;
		}
	}
}
