package game {
	public class ObserverManager {
		private static var instance : ObserverManager;
		private var observerData : Array;

		public function ObserverManager() : void {
			observerData = new Array();
		}

		public static function getInstance() : ObserverManager {
			if (instance == null)
				instance = new ObserverManager();
			return instance;
		}

		public function subscribe(observer : IObserver) : void {
			observerData.push(observer);
		}

		public function unsubscribe(observer : IObserver) : void {
			var totObs : int = observerData.length;
			for (var i : int = 0; i < totObs; i++) {
				if (observer === observerData[i]) {
					observerData.splice(i, 1);
					break;
				}
			}
		}

		public function notify(_notification : Object) : void {
			var totObs : int = observerData.length;
			for (var i : int = 0; i < totObs; i++) {
				observerData[i]['updateObserver'](_notification);
			}
		}
	}
}
