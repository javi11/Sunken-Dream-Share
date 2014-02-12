package game {
	/**
	 * Contiene las constantes del juego 
	 * 
	 * @author Javier
	 * 
	 */
	public class GameConstants {
		// Animaciones
		public static const HERO_STATE_IDLE : int = 0;
		public static const HERO_STATE_WALKING : int = 1;
		public static const HERO_STATE_HURT : int = 2;
		public static const HERO_STATE_JUMP : int = 3;
		public static const HERO_STATE_DUCK : int = 4;
		// Hero properties -----------------------------------------
		/** Vida inicial */
		public static const HERO_HP : int = 100;
		/** Nombre */
		public static const NAME : String = "Prota";
		/** Velocidad */
		public static const HERO_MIN_SPEED : Number = 650;
		/** Gravedad */
		public static const GRAVITY : Number = 10;
	}
}
