package game.wepons
{
	import citrus.objects.Box2DPhysicsObject;
	
	public class CocoCannon extends Box2DPhysicsObject
	{
		public function CocoCannon(name:String,params:Object = null)
		{
			super(name,params);
		}
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
	}
}