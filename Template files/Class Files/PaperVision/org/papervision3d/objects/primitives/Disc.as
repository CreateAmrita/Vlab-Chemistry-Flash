
      package org.papervision3d.objects.primitives
  
      {

      import org.papervision3d.core.geom.*;
  
      import org.papervision3d.core.geom.renderables.Vertex3D;
  
      import org.papervision3d.core.proto.*;

      public class Disc extends TriangleMesh3D
  
      {
  
      private var segments :uint;
  
      private var sides :uint;
  
      private var radius :Number;
  
      private var sideIncrement:Number;
  
      private var currentIncrement:Number = 0;
  
       
  
      public function Disc (material:MaterialObject3D=null, radius:Number=100, segments:uint=0, sides:uint=3, sideIncrement:Number=0, initObject:Object=null )
  
      {

      super(material, new Array(), new Array());

      this.segments = 1+ segments;

      this.sides = sides;
 
      this.radius = radius;

      this.sideIncrement = sideIncrement;
 
      buildDisc();
 
      }

      private function buildDisc():void
 
      {
 
      var matInstance:MaterialObject3D = material;
  
      var i:Number, j:Number, k:Number;

       
 
      var aVertice:Array = this.geometry.vertices;
 
      var fZ:Number = 0;
  
      var oVtx:Vertex3D;
  
      oVtx = new Vertex3D(0,0,0);
 
      aVertice.push(oVtx);

      for (j = 0; j < segments; j++) {
 
      currentIncrement += sideIncrement;

      var curSides:uint = uint(Math.floor(sides + currentIncrement));
  
      for (i = 0; i < curSides; i++) {

      var fRds:Number = (j + 1) * radius / segments;

      var fX:Number = fRds*Math.sin(i*(2*Math.PI/curSides));

      var fY:Number = fRds*Math.cos(i*(2*Math.PI/curSides));

      oVtx = new Vertex3D(fY,fZ,fX);

      aVertice.push(oVtx);
 
      }
       }

      this.geometry.ready = true;
  
      }
 
      
	  }
	  }