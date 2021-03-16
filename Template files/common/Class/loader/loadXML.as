/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


/* Class for loading an external XML */
package loader{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.MovieClip;
	public class loadXML extends MovieClip {
		public var xmlLoader:URLLoader = new URLLoader();
		public var xmlData:XML=new XML  ;
		public var success:Boolean=false;
		//constructor
		public function loadXML(XMLurl:String,MainStage:Object) {

			xmlLoader.load(new URLRequest(XMLurl));
			xmlLoader.addEventListener(Event.COMPLETE, showXML);
			function showXML(e:Event):void {
			xmlData=new XML(e.target.data);
			MainStage.afterXMLLoaded();
			
		}
		}
		public function getXML():XML
		{
			trace(xmlData);
			return(xmlData);
		}
		
		
	}
}