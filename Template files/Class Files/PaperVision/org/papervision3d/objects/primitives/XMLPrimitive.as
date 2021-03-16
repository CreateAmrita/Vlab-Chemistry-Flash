package org.papervision3d.objects.primitives  {
	
	import flash.events.Event;
	import flash.net.*;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;
	

	public class XMLPrimitive extends TriangleMesh3D {
		private var ve:Array;
		private var fa:Array;
		
		public var myFileGet:String;
		public var xmlReq:URLRequest;
		public var xmlLoader:URLLoader;
		public var myData_xml:XML;
		public var iFacNum:Number;
		public var myMaterial:MaterialObject3D;
	
		public function XMLPrimitive(myFileGet:String, material :MaterialObject3D=null, initObject:Object=null ) {
			super( material, new Array(), new Array(),null );
			ve = this.geometry.vertices;
			fa = this.geometry.faces;
			
			
			
			var externalXML:XML;
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(myFileGet);
			
			
			loader.load(request);
			
		
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			function onComplete(event:Event):void
			{
			    var loader:URLLoader = event.target as URLLoader;
			    if (loader != null)
			    {
			        externalXML = new XML(loader.data);
			        
			        
			        buildCylinder(externalXML);
			        
			        
			    }
			    else
			    {
			        trace("loader is not a URLLoader!");
			    }
			} 
			
	
			this.geometry.ready = true;
		}
		
		private function buildCylinder(myData_xml:XML):void
		{
			
		
		
		ve = this.geometry.vertices;
		fa = this.geometry.faces;
		var mySlitVert:Array=myData_xml.myPrimSet[0].myVertices.split(",");
		var mySlitFace:Array=myData_xml.myPrimSet[0].myFaces.split(",");
		this.geometry.ready = true;
		
		var j:int;
		var iVerNum:int=(mySlitVert.length-1)/3;
		for (j=0;j<iVerNum;j++) {
			
			v(mySlitVert[j*3],mySlitVert[j*3+1],mySlitVert[j*3+2]);
		
		}
		
		//if statement for material or no material
		
		if(mySlitFace[mySlitFace.length-1]==0){
		
		var k:int;
		iFacNum=(mySlitFace.length-1)/3;
		for (k=0;k<iFacNum;k++) {
			
			f2(mySlitFace[k*3],mySlitFace[k*3+1],mySlitFace[k*3+2]);
			
			}
			}else{
		var n:int;
		iFacNum=(mySlitFace.length-1)/12;
		for (n=0;n<iFacNum;n++) {
			
            f(mySlitFace[n*12], mySlitFace[n*12+1], mySlitFace[n*12+2], mySlitFace[n*12+3], mySlitFace[n*12+4], mySlitFace[n*12+5], mySlitFace[n*12+6], mySlitFace[n*12+7], mySlitFace[n*12+8], mySlitFace[n*12+9], mySlitFace[n*12+10], mySlitFace[n*12+11]);
			
			}
		
		}
		
		}
		
		
		public function v(x:Number, y:Number, z:Number):void {
			ve.push(new Vertex3D(x, y, z));
		}
        //Function for material on prims
		public function f(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {
			var face : Triangle3D = new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], material, [ new NumberUV(uv00, uv01), new NumberUV(uv10, uv11), new NumberUV(uv20, uv21) ] );
			face.faceNormal = new Number3D(normalx,normaly,normalz);
			fa.push(face);
		
		}

		public function f2(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number):void {
		fa.push(new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], material, []));
		
		}

	}
}





