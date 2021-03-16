/*
File:Commonfunction.as
Developer:Shambhu.k
Discription:Class for loading an external SWF
*/

package loader{
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import common.commonfunctions;

	public class loadSWF extends MovieClip {
		//Private Variables

		private var swfLoadervalue:Loader;
		public var preLoader:Loader=new Loader();;

		//Public Variables

		public var preloaderSWF:MovieClip=new MovieClip();
		public var swfFile:MovieClip=new MovieClip();

		//constructor have to pass the preloader,swf path and boolean variable for playing next frame
		public function unloadSWF(){
			preLoader.unloadAndStop();
	}

		public function loadSWF(url:String,path:String,MainStage:Object,B:Boolean) {
			preLoader=new Loader();
			//loading preloader
			preLoader.load(new URLRequest(path));
			preLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,preLoaderComplete);

			/*Calls when the preloader is completed*/

			function preLoaderComplete(loadEvent:Event) {
				preloaderSWF=loadEvent.currentTarget.content as MovieClip;
				//Setting the position of the loader
				preloaderSWF.x=300;
				preloaderSWF.y=200;
				MainStage.addChild(preloaderSWF);
				//Passing the swf path after preloaer loaded
				showSWF(url,MainStage,B);
			}

		}
		//Function to load the swf
		/*B is the variable to identify the frame has been loaded 
		if B is tru it will go to next frame of the main file.*/
		public function showSWF(url:String,MainStage:Object,B:Boolean) {
			swfLoadervalue=new Loader();
			swfLoadervalue.load(new URLRequest(url));
			swfLoadervalue.contentLoaderInfo.addEventListener(Event.COMPLETE,funcComplete);
			function funcComplete(completeEvent:Event) {
				MainStage.removeChild(preloaderSWF);
				swfFile=completeEvent.currentTarget.content as MovieClip;
				addChild(swfFile);
				MainStage.afterSWFLoaded();
			}
			

		}
	}
}