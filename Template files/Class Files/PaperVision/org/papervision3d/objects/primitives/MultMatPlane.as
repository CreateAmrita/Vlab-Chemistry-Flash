package org.papervision3d.objects.primitives {

	import org.papervision3d.Papervision3D;
	import org.papervision3d.core.geom.*;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.*;
	import org.papervision3d.materials.utils.MaterialsList;	
//He that refuseth instruction despiseth his own soul: but he that heareth reproof getteth understanding.

	/**
	* The Plane class lets you create and display flat rectangle objects.
	* <p/>
	* The rectangle can be divided in smaller segments. This is usually done to reduce linear mapping artifacts.
	* <p/>
	* Dividing the plane in the direction of the perspective or vanishing point, helps to reduce this problem. Perspective distortion dissapears when the plane is facing straignt to the camera, i.e. it is perpendicular with the vanishing point of the scene.
	*/
	public class MultMatPlane extends TriangleMesh3D
	{
		/**
		* Number of segments horizontally. Defaults to 1.
		*/
		public var segmentsW :Number;
	
		/**
		* Number of segments vertically. Defaults to 1.
		*/
		public var segmentsH :Number;
		
		public var myGap:Number;
		
		public var horizNum:int;
		public var vertiNum:int;
		

		/**
		* Default size of Plane if not texture is defined.
		*/
		static public var DEFAULT_SIZE :Number = 500;
	
		/**
		* Default size of Plane if not texture is defined.
		*/
		static public var DEFAULT_SCALE :Number = 1;
	
		/**
		* Default value of gridX if not defined. The default value of gridY is gridX.
		*/
		static public var DEFAULT_SEGMENTS :Number = 1;
	
	
		// ___________________________________________________________________________________________________
		//                                                                                               N E W
		// NN  NN EEEEEE WW    WW
		// NNN NN EE     WW WW WW
		// NNNNNN EEEE   WWWWWWWW
		// NN NNN EE     WWW  WWW
		// NN  NN EEEEEE WW    WW
	
		/**
		* Create a new Plane object.
		* <p/>
		* @param	material	A MaterialObject3D object that contains the material properties of the object.
		* <p/>
		* @param	width		[optional] - Desired width or scaling factor if there's bitmap texture in material and no height is supplied.
		* <p/>
		* @param	height		[optional] - Desired height.
		* <p/>
		* @param	segmentsW	[optional] - Number of segments horizontally. Defaults to 1.
		* <p/>
		* @param	segmentsH	[optional] - Number of segments vertically. Defaults to segmentsW.
		* <p/>
		* @param	initObject	[optional] - An object that contains user defined properties with which to populate the newly created GeometryObject3D.
		* <p/>
		* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
		* <p/>
		* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
		*/
		public function MultMatPlane( materials:MaterialsList, myGap:Number=0,horizNum:int=1, vertiNum:int=1,  width:Number=0, height:Number=0, segmentsW:Number=0, segmentsH:Number=0, initObject:Object=null )
		{
			super( materials.getMaterialByName( "all" ), new Array(), new Array(), null );
			
			this.materials = materials;
			
			this.segmentsW = segmentsW || DEFAULT_SEGMENTS; // Defaults to 1
			this.segmentsH = segmentsH || this.segmentsW;   // Defaults to segmentsW
			
			this.myGap=myGap;
			
			this.horizNum=horizNum;
		    this.vertiNum=vertiNum;
	
			var scale :Number = DEFAULT_SCALE;
	
			if( ! height )
			{
				if( width )
					scale = width;
	
				if( material && material.bitmap )
				{
					width  = material.bitmap.width  * scale;
					height = material.bitmap.height * scale;
				}
				else
				{
					width  = DEFAULT_SIZE * scale;
					height = DEFAULT_SIZE * scale;
				}
			}
	

			buildMultiPlane(myGap,horizNum,vertiNum, width, height );
			
	
		}
		
		
		private function buildMultiPlane(myGap:Number, horizNum:Number, vertiNum:Number, width:Number, height:Number ):void
		{
			
		
				
					
				for(var n:int=0; n <vertiNum; n++){
						
					for(var m:int=0; m <horizNum; m++){	
							
				var myMaterial:String = "myMat"+""+n+""+m;
				
				trace("myMat"+""+n+""+m);
				
				buildPlane( myMaterial, myGap, m, n, horizNum, vertiNum, width, height) ;	
					trace("makingPlane"+n);
					}
				}
				
	
			mergeVertices();
	
			this.geometry.ready = true;
			
		
				
				
				
		}
		
		
		
	
		private function buildPlane(myMaterial:String, myGap:Number, m:int, n:int, horizNum:int, vertiNum:int, width:Number, height:Number ):void
		{
			
			var matInstance:MaterialObject3D;
			if( ! (matInstance= materials.getMaterialByName( myMaterial )))
			{
				if(!(matInstance=materials.getMaterialByName( "all" ))){
					Papervision3D.log( "MultiPlane: Required material not found in given materials list. Supported materials are: front, back, right, left, top, bottom & all." );
					return;
				}
			}
			
			
			var gridX    :Number = this.segmentsW;
			var gridY    :Number = this.segmentsH;
			var gridX1   :Number = gridX + 1;
			var gridY1   :Number = gridY + 1;
	
			var vertices :Array  = this.geometry.vertices;
			var faces    :Array  = this.geometry.faces;
			var planeVerts :Array = new Array();
	
			var textureX :Number = width;
			var textureY :Number = height;
	
			var iW       :Number = width / gridX;
			var iH       :Number = height / gridY;
	
			// Vertices
			for( var ix:int = 0; ix < gridX + 1; ix++ )
			{
				for( var iy:int = 0; iy < gridY1; iy++ )
				{
					var x :Number = ix * iW -(textureX+myGap/2)*(horizNum/2-m);
					var y :Number = iy * iH -(textureY+myGap/2)*(vertiNum/2-n);
	
					var vertex:Vertex3D = new Vertex3D();
					
					vertex[ "x" ] = x;
					vertex[ "y" ] = y;
					vertex[ "z" ] = 0;
					
					vertices.push( vertex );
					planeVerts.push( vertex );
					
					
				}
			}
	
			// Faces
			var uvA :NumberUV;
			var uvC :NumberUV;
			var uvB :NumberUV;
	
			for(  ix = 0; ix < gridX; ix++ )
			{
				for(  iy= 0; iy < gridY; iy++ )
				{
					// Triangle A
					var a:Vertex3D = planeVerts[ ix     * gridY1 + iy     ];
					var c:Vertex3D = planeVerts[ ix     * gridY1 + (iy+1) ];
					var b:Vertex3D = planeVerts[ (ix+1) * gridY1 + iy     ];
	
					uvA =  new NumberUV( ix     / gridX, iy     / gridY );
					uvC =  new NumberUV( ix     / gridX, (iy+1) / gridY );
					uvB =  new NumberUV( (ix+1) / gridX, iy     / gridY );
	
					faces.push(new Triangle3D(this, [ a, b, c ], matInstance, [ uvA, uvB, uvC ] ) );
	
					// Triangle B
					a = planeVerts[ (ix+1) * gridY1 + (iy+1) ];
					c = planeVerts[ (ix+1) * gridY1 + iy     ];
					b = planeVerts[ ix     * gridY1 + (iy+1) ];
	
					uvA =  new NumberUV( (ix+1) / gridX, (iy+1) / gridY );
					uvC =  new NumberUV( (ix+1) / gridX, iy      / gridY );
					uvB =  new NumberUV( ix      / gridX, (iy+1) / gridY );
					
					faces.push(new Triangle3D(this, [ a, b, c ], matInstance, [ uvA, uvB, uvC ] ) );
				}
			}
	
			
		}
	}
}