package virtualcircuit.logic.collision
{	
	import flash.display.DisplayObject;

	public class CollisionGroup extends CDK
	{
		public function CollisionGroup(... objs):void 
		{
			for(var i:uint = 0; i < objs.length; i++)
			{
				addItem(objs[i]);
			}
		}
		
		public function checkCollisions():Array
		{
			clearArrays();
			
			var NUM_OBJS:uint = objectArray.length, item1:DisplayObject, item2:DisplayObject;
			for(var i:uint = 0; i < NUM_OBJS - 1; i++)
			{
				item1 = DisplayObject(objectArray[i]);
				
				for(var j:uint = i + 1; j < NUM_OBJS; j++)
				{
					item2 = DisplayObject(objectArray[j]);
					
					if(item1.hitTestObject(item2))
					{
						if((item2.width * item2.height) > (item1.width * item1.height))
						{
							objectCheckArray.push([item1,item2])
						}
						else
						{
							objectCheckArray.push([item2,item1]);
						}
					}
				}
			}
			
			NUM_OBJS = objectCheckArray.length;
			for(i = 0; i < NUM_OBJS; i++)
			{
				findCollisions(DisplayObject(objectCheckArray[i][0]), DisplayObject(objectCheckArray[i][1]));
			}
			
			return objectCollisionArray;
		}
	}
}