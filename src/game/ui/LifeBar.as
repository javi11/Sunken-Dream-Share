package game.ui {
	import game.Assets;
	import game.GameConstants;

	import starling.display.Image;
	import starling.display.Sprite;

	/**
	 * @author Javier
	 */
	public class LifeBar extends Sprite {
		private var _maxHP : Number = 100;
		private var _currentHP : Number = 60;
		private var _percentHP : Number = _currentHP / _maxHP;
		private var _lifeBar : Image;
		private var _life : Image;
		private static var _instance : LifeBar;

		public static function getInstance() : LifeBar {
			if (!_instance) {
				_instance = new LifeBar();
			}
			return _instance;
		}

		public function LifeBar() : void {
			_lifeBar = new Image(Assets.getAtlas('ui').getTexture("barraVida"));
			_life = new Image(Assets.getAtlas('ui').getTexture("vida"));
			_life.x = 43;
			_life.y = 19;
			_maxHP = GameConstants.HERO_HP;

			addChild(_lifeBar);
			addChild(_life);
			updateLifeBar();
		}

		public function handleDamage(damage : int) : void {
			_currentHP -= damage;
			if (_currentHP <= 0)
				_currentHP = 0;
			updateLifeBar();
		}

		public function handleCure(hp : int) : Boolean {
			if (_currentHP < _maxHP) {
				_currentHP += hp;
				if (_currentHP > _maxHP) {
					_currentHP = _maxHP;
				}
				updateLifeBar();
				return true;
			} else {
				return false;
			}
		}

		private function updateLifeBar() : void {
			if (_currentHP >= 0) {
				_percentHP = _currentHP / _maxHP;
				_life.scaleX = _percentHP;
			}
		}
	}
}
