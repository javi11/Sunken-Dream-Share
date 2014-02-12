package game.levels {
	import citrus.core.CitrusObject;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.view.ICitrusArt;
	import citrus.view.starlingview.AnimationSequence;

	import game.Assets;

	import flash.utils.getDefinitionByName;

	/**
	 * @author Javier
	 */
	public class EventByRemote extends Sensor {
		private var _message : String;
		private var _activeView : String;
		private var _idleView : String;
		public var animationSequence : AnimationSequence;
		private var _removedObject : CitrusObject;

		public function EventByRemote(name : String, params : Object = null) : void {
			super(name, params);
			touchable = true;
			_message = params['message'];
			_activeView = params['texture'] + "active";
			_idleView = params['texture'] + "idle";
			animationSequence = new AnimationSequence(Assets.getAtlas('levelA' + params['lv'] + 'Events'), [_idleView, _activeView], _idleView);
			view = animationSequence;
			var objects : Array = [];
		}

		public function getMessage() : String {
			return _message;
		}

		public function active() : void {
			_animation = _activeView;
		}

		public function desActive() : void {
			_animation = _idleView;
			_ce.state.add(_removedObject);
		}

		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			if (animationName == _activeView) {
				switch(_params['action']) {
					case 'drop':
						var levelXmL : XML = Assets.getConfig("levelA1Xml");
						var item : XMLList = levelXmL['items'][_params['drop']];
						var object : LevelObjects = new LevelObjects(item['nameObject'], {x:this.x, y:this.y, width:30, height:30, group:3, properties:item});
						_ce.state.add(object);
						break;
					case 'removeObject':
						_removedObject = _ce.state.getObjectByName(_params['object']);
						_ce.state.remove(_removedObject);
						break;
					case 'addObject':
						var citrusObject:CitrusObject = AddObject.get(_params);
						_ce.state.add(citrusObject);
						break;
				}
			}
		}
	}
}
