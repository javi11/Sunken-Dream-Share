package game.levels {
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.view.ICitrusArt;
	import citrus.view.starlingview.AnimationSequence;

	import game.Assets;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;

	/**
	 * @author Javier
	 */
	public class RemoteActivator extends Sensor {
		private var _message : String;
		private var _activeView : String;
		private var _idleView : String;
		private var _unActiveView : String;
		public var animationSequence : AnimationSequence;
		private var _inventory : Inventory;

		public function RemoteActivator(name : String, params : Object = null) : void {
			super(name, params);
			touchable = true;
			_message = params['message'];
			_activeView = params['texture'] + "active";
			_idleView = params['texture'] + "idle";
			_unActiveView = params['texture'] + "unActive";
			animationSequence = new AnimationSequence(Assets.getAtlas('levelA' + params['lv'] + 'Events'), [_idleView, _activeView], _idleView);
			view = animationSequence;
			_inventory = Inventory.getInstance();
			if (params['contactType'] || params['buttonType'] ) {
				onBeginContact.add(_active);
			}
			if (params['buttonType']) {
				onEndContact.add(_unActive);
			}
		}

		public function isTheKey(object : GameObject) : Boolean {
			if (object.get("nameObject") == _params['key']) {
				_active();
				return true;
			} else {
				return false;
			}
		}

		public function getMessage() : String {
			return _message;
		}

		private function _active() : void {
			if (_params['contactType']) {
				onBeginContact.remove(_active);
			}
			_animation = _activeView;
		}

		private function _unActive() : void {
			_animation = _unActiveView;
		}

		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			var activateEvent : EventByRemote = _ce.state.getObjectByName(_params['activate']) as EventByRemote;
			if (animationName == _activeView) {
				activateEvent.active();
			} else if (animationName == _unActiveView) {
				activateEvent.desActive();
			}
		}
	}
}
