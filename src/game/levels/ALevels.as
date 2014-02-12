package game.levels {
	import game.PassiveAI;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.ui.starling.basic.BasicUI;
	import citrus.ui.starling.basic.BasicUILayout;

	import game.Assets;
	import game.Inventory.Inventory;
	import game.PhysicBox;
	import game.Player;
	import game.ui.LifeBar;

	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import org.osflash.signals.Signal;

	import flash.geom.Rectangle;

	/**
	 * @author Javier
	 */
	public class ALevels extends StarlingState {
		public var lvlEnded : Signal;
		public var restartLevel : Signal;
		private var _inventory : Inventory;
		private var _ui : BasicUI;
		public var _lifeBar : game.ui.LifeBar;

		public function ALevels() : void {
			super();
			_inventory = Inventory.getInstance();

			lvlEnded = new Signal();
			restartLevel = new Signal();

			var objects : Array = [PassiveAI,EventByCollision, EventByObject, EventByRemote, Platform, CitrusSprite, Player, PhysicBox, Stairs, Elevator, ShootingCannon];
		}

		override public function initialize() : void {
			super.initialize();

			var box2d : Box2D = new Box2D("box2D", {visible:false});
			add(box2d);

			view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			setupUi();

			_ce.onStageResize.add(function() : void {
				_ui.setFrame(0, 0, stage.stageWidth, stage.stageHeight);
			});
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		protected function setupUi() : void {
			// Inicializar interfaz de usuario
			BasicUI.defaultContentScale = 0.6;
			_ui = new BasicUI(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_ui.container.alpha = 0.7;
			_ui.padding = 15;
			// Añadimos Elementos
			_lifeBar = LifeBar.getInstance();
			_ui.add(_lifeBar, BasicUILayout.TOP_LEFT);
			var inventoryButton : Button;
			inventoryButton = new Button(Assets.getAtlas('ui').getTexture("mochila"));
			inventoryButton.useHandCursor = true;
			inventoryButton.addEventListener(Event.TRIGGERED, handleOpenInventory);
			_inventory.inventoryView.addEventListener(Event.REMOVED, handleCloseInventory);
			_ui.add(inventoryButton, BasicUILayout.TOP_CENTER);
		}

		private function handleOpenInventory() : void {
			if (!_inventory.isVisible) {
				_ce.playing = false;
				_inventory.showInventory(Assets.getAtlas('ui'));
				_ui.add(_inventory, BasicUILayout.MIDDLE_CENTER);
				_ui.container.alpha = 1;
			} else {
				_ce.playing = true;
				_inventory.removeInventory();
				_ui.container.alpha = 0.7;
			}
		}

		private function handleCloseInventory() : void {
			_ce.playing = true;
			_ui.container.alpha = 0.7;
		}

		override public function destroy() : void {
			super.destroy();
			_ui.destroy();
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
		}

		private function handleLoadComplete() : void {
			
			// remove loader
		}

		private function touchHandler(e : TouchEvent) : void {
			var touchEnd : Touch = e.getTouch(this, TouchPhase.ENDED);
			var target : Quad = e.target as Quad;
			if (touchEnd) {
				
				if (target is MovieClip) {
					var object : Object = (_ce.state.view.getObjectFromArt(target.parent.parent));
					var player1 : Player = _ce.state.getObjectByName("Player") as Player;
					if (object is EventByCollision) {
						player1.talk(EventByCollision(object).getMessage());
					} else if (object is EventByObject) {
						player1.talk(EventByObject(object).getMessage());
					} else if (object is EventByRemote) {
						player1.talk(EventByRemote(object).getMessage());
					} else if (object is Elevator) {
						player1.talk(Elevator(object).getMessage());
					}
				}
			}
		}
	}
}