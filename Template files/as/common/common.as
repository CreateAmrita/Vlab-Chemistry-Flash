stop();
import flash.display.StageDisplayState;
//import flash.display.StageAlign;
//import flash.display.StageScaleMode;
//stage.align=StageAlign.TOP_LEFT;
//stage.scaleMode=StageScaleMode.NO_SCALE;
/////
var spArray=new Array();
/////
var DocName:String=new String("");
var HelpDocName:String=new String("");
var TopBoxValue:String=new String("");
var BottomBoxValue:String=new String("");
var flag_helpDoc:Number=0;
/////
var pHeight:Number=800;
var pWidth:Number=600;
var Template="frame.swf";
var stImage:String="../../../Common/Templates/Classic/"+Template;
var MCTemplate:MovieClip=new MovieClip();
///////////////////////////////
import flash.net.URLRequest;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import com.adobe.images.JPGEncoder;

//////////////////////////////
function startLoad() {
	var mLoader:Loader = new Loader();
	var mRequest:URLRequest=new URLRequest(stImage);
	mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
	mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
	mLoader.load(mRequest);
}
///////
function onCompleteHandler(loadEvent:Event) {
	MCTemplate=loadEvent.currentTarget.content as MovieClip;
	MCTemplate.ExperimentName.text=TempHeading;
	MCTemplate.topBoxText.text=TopBoxValue;
	MCTemplate.bottomBoxText.text=BottomBoxValue;
	MCTemplate.Doc.addEventListener(MouseEvent.CLICK, showHelpDoc);
	MCTemplate.HelpDoc.addEventListener(MouseEvent.CLICK, showHelpDoc);
	MCTemplate.FullScreenButton.addEventListener(MouseEvent.CLICK, _handleClick);
	if (MCTemplate.ScreenShot) {
		MCTemplate.ScreenShot.addEventListener(MouseEvent.CLICK, saveScreenShot);
	}
	addChild(MCTemplate);
	play();
}
var DocName1="";
function showHelpDoc(e:MouseEvent) {
	if (e.target.parent.name=="Doc") {
		if (DocName1==DocName) {
			if (spArray.length>0) {
				trace("11if");
				flag_helpDoc=1;
			}
		} else {
			flag_helpDoc=0;
			DocName1=DocName;
		}
	} else if (e.target.parent.name=="HelpDoc") {
		if (DocName1==HelpDocName) {
			if (spArray.length>0) {
				flag_helpDoc=1;
			}
		} else {
			flag_helpDoc=0;
			DocName1=HelpDocName;
		}
	}
	if (HelpDocName!="") {
		if (spArray.length>0) {
			removeChild(spArray[spArray.length-1]);
			spArray.pop();
		}
		if (! flag_helpDoc) {
			import fl.containers.ScrollPane;
			var sp:ScrollPane=new ScrollPane();
			sp.x=15;
			sp.y=87;
			sp.setSize(580, 485);
			sp.name="DocContainer";
			sp.source=DocName1;
			addChild(sp);
			spArray.push(sp);
			flag_helpDoc=1;
		} else {
			flag_helpDoc=0;
		}
	}
}
function onProgressHandler(mProgress:ProgressEvent) {
	var percent:Number=mProgress.bytesLoaded/mProgress.bytesTotal;
}
////// For fullscreen button
function goFullScreen():void {
	if (stage.displayState==StageDisplayState.NORMAL) {
		stage.displayState=StageDisplayState.FULL_SCREEN;
	} else {
		stage.displayState=StageDisplayState.NORMAL;
	}
}

function _handleClick(event:MouseEvent):void {
	goFullScreen();
}
function saveScreenShot(evt:MouseEvent):void {
	var jpgSource:BitmapData=new BitmapData(stage.stageWidth,stage.stageHeight);
	jpgSource.draw(stage.root);
	var file:FileReference = new FileReference();
	var jpgEncoder:JPGEncoder=new JPGEncoder(80);
	file.save(jpgEncoder.encode(jpgSource), "image-"+Math.random()+".jpg");
}
///////////

startLoad();
//////////