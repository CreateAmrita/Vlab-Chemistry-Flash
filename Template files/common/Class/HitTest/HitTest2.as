/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package HitTest{

	public class HitTest2 {
		import flash.display.DisplayObject;
		import flash.display.BitmapData;
		import flash.geom.ColorTransform;
		import flash.geom.Matrix;
		import flash.geom.Rectangle;

		public function HitTestObject(object1:DisplayObject, object2:DisplayObject, pixelPerfect:Boolean=true, tolerance:int = 255):Rectangle {
			
			// quickly rule out anything that isn't in our hitregion
				if (object1.hitTestObject(object2)) {
				
				// get bounds:
				var bounds1:Rectangle=object1.getBounds(object1.parent.parent.parent);
				var bounds2:Rectangle=object2.getBounds(object2.parent.parent.parent);

				// determine test area boundaries:
				var bounds:Rectangle=bounds1.intersection(bounds2);
				bounds.x=Math.floor(bounds.x);
				bounds.y=Math.floor(bounds.y);
				bounds.width=Math.ceil(bounds.width);
				bounds.height=Math.ceil(bounds.height);
				
				//ignore collisions smaller than 1 pixel
				if ((bounds.width < 1) || (bounds.height < 1)) {

					return null;

				}

				if (! pixelPerfect) {

					return bounds;
				}

				// set up the image to use:
				var img:BitmapData=new BitmapData(bounds.width,bounds.height,false);

				// draw in the first image:
				var mat:Matrix=object1.transform.concatenatedMatrix;
				mat.translate( -bounds.left, -bounds.top);
				img.draw(object1,mat, new ColorTransform(1,1,1,1,255,-255,-255,tolerance));

				// overlay the second image:
				mat=object2.transform.concatenatedMatrix;
				mat.translate( -bounds.left, -bounds.top);
				img.draw(object2,mat, new ColorTransform(1,1,1,1,255,255,255,tolerance),"difference");

				// find the intersection:
				var intersection:Rectangle=img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);

				// if there is no intersection, return null:

				if (intersection.width==0) {
					return null;
				}

				// adjust the intersection to account for the bounds:
				intersection.offset(bounds.left, bounds.top);

				return intersection;
			} else {
				
				return null;
			}

		}
	}
}