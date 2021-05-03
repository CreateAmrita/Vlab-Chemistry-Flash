package common{
import flash.net.URLRequest;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.display.Sprite;

	public class template extends Sprite {

private var Template="Frame.swf";
private var stImage:String="../../../Common/Templates/Classic/"+Template;


public function template() {
	var mLoader:Loader = new Loader();
	var mRequest:URLRequest=new URLRequest(stImage);
	mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
	mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
	mLoader.load(mRequest);
	
}

private function onCompleteHandler(loadEvent:Event) {

	addChild(loadEvent.currentTarget.content);
	trace("amma");
}
private function onProgressHandler(mProgress:ProgressEvent) {
	var percent:Number=mProgress.bytesLoaded/mProgress.bytesTotal;
	trace(percent);
}
	}
}

