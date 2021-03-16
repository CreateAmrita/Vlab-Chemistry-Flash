package org.papervision3d.objects.primitives {
        import org.papervision3d.core.geom.TriangleMesh3D;
        import org.papervision3d.core.geom.renderables.Triangle3D;
        import org.papervision3d.core.geom.renderables.Vertex3D;
        import org.papervision3d.core.proto.MaterialObject3D;   
    import org.papervision3d.core.math.NumberUV;
    

        
        public class PolyPlane extends TriangleMesh3D
        {
                
                /**
                * Default size of Plane if not texture is defined.
                */
                static public var DEFAULT_SIZE :Number = 500;
        
                /**
                * Default size of Plane if not texture is defined.
                */
                static public var DEFAULT_SCALE :Number = 1;
                

                public function PolyPlane( material :MaterialObject3D=null, sidesNum:int=3,width:Number=0, height:Number=0 )
                {
                        super( material, new Array(), new Array(), null );
        
                        scale = scale || DEFAULT_SCALE;
        
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
        
                        buildPolyPlane( sidesNum, width, height );
                }
                
        
        
                private function buildPolyPlane(sidesNum:int,width:Number, height:Number ):void
                {
                
                        
                        if(sidesNum<3){sidesNum=3;};
                        
                        var myXScale :Number = 100 * width;
                        var myYScale :Number = 100 * height;
                        
                
                    var vertices :Array  = this.geometry.vertices;
                    var faces    :Array  = this.geometry.faces;
                        
        
                var myTheta:Number=360/sidesNum;
        
                        // Vertices
                        
                            vertices.push( new Vertex3D( 0, 0, 0 ) );
                        
                                for( var i:int = 0; i <= sidesNum; i++ )
                                {
                                        
                                        var x :Number = myXScale * Math.sin(myTheta*i*Math.PI/180);
                                        
                                        var y :Number = myYScale * Math.cos(myTheta*i*Math.PI/180);
                                        
                                        vertices.push( new Vertex3D( x, y, 0 ) );
                                        
                                        trace(x);
                                        trace(y);
                                        
                                        
                                }
                                
        
                        for(  i = 1; i <= sidesNum; i++ )
                        {
                                
                    
                                        var a:Vertex3D = vertices[ i ];
                                        var b:Vertex3D = vertices[(i+1)];
                                        var c:Vertex3D = vertices[ 0 ];
                                
                                        
                                        
                                        faces.push(new Triangle3D(this, [ a, b, c ], material ) );
                        
                        }
                        

                        this.projectTexture( "x", "z" );
        
                        this.geometry.ready = true;
                        
                        //I am the living bread which came down from heaven: if any man eat of this bread, he shall live for ever: and the bread that I will give is my flesh, which I will give for the life of the world
                
        }
}}
