/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

/*
Discription:The Class contain all the common function that can be used for experiments
*/
package common{
	import flash.display.MovieClip;
	import fl.controls.Label;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import fl.motion.Color;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.display.StageDisplayState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.events.*;
	import flash.display.DisplayObject;
	import fl.containers.ScrollPane;
	import flash.utils.getDefinitionByName;

	import loader.loadSWF;//importing loadSWF class
	import bookMark.bookmarkLoad;//importing bookmarkLoad class..
	import loader.loadXML;//importing loadXML class
	import other.loadXmlData;//importing loadXML class
	import com.adobe.images.JPGEncoder;
	//import 
	public class commonfunctions extends MovieClip {
		var tempframe:MovieClip=new MovieClip();
		var themeName = "";//Theme foldername 
		var preloaderTheme = "";//Preloader of the theme
		var actionbuttonTheme = "";//Preloader of the theme
		var swfpath:String;//="../Theme/"+themeName+"/frame.swf";
		var preloaderpath:String;//="../Theme/"+themeName+"/"+preloaderTheme+"/preloader.swf";
		var actionbuttonpath:String;
		var menupath:String;//="../Theme/"+themeName+"/"+actionbuttonTheme+"/actionbutton.swf";
		var scenesValues:Array=new Array();
		private var intervalID:uint;
		private var previousSwf:Object=new Object();
		public var echotxt:TextField = new TextField();

		//var XMLReader:XMLTextReader=new XMLTextReader();
		public var newXML:loadXML;
		public var newSWF:MovieClip=new MovieClip();
		public var stageall:Object;
		public var NumberOfSwf:Number = 1;
		public var framesandlabels:loadXmlData=new loadXmlData();
		public var bookclips:Array=new Array();

		/*The frame and menu are used to load the template and the menu of the experiment.
		All the vaiables in the frame have to set through this variables*/
		public var frame:MovieClip;
		public var menu:MovieClip;
		//This is used to get load the action buttons of the experiment
		public var actionButton:MovieClip;

		////For dispaly swf file name,scene name , and frame number
		public var key:uint = 0;
		public var echoFileNameArray:Array = new Array();
		public var echoFormat:TextFormat = new TextFormat();
		public var thisSWF:String;
		public var bookmark;

		public function commonfunctions(stage1:Object,theme:String,preloader:String,menusend:String="") {//Have to pass the stage
			/*Loading the Frame to the stage */

			themeName = theme;//Theme foldername 
			preloaderTheme = preloader;//Preloader of the theme
			if ((stage1.lan==undefined) ||(stage1.lan=="") ) {
				swfpath = "../../../Common/Templates/" + themeName + "/frame.swf";
			} else {
				swfpath = "../../../Common/Templates/" + themeName + "/frame-" + stage1.lan + ".swf";
			}
			preloaderpath = "../../../Common/Templates/" + themeName + "/" + preloaderTheme + "/preloader.swf";
			stageall = stage1;
			frame = loadnewSWF(swfpath,true);
			addChild(frame);

			////For dispaly swf file name,scene name , and frame number
			addChild(echotxt);
			echotxt.autoSize = TextFieldAutoSize.RIGHT;
			echoFormat.color = 0xCCCCCC;
			echoFormat.size = 12;
			echotxt.x +=  650;
			echotxt.y +=  550;

			/*If the Menu is present in the experiment it will load the menu .
			All the Sumulators have menus.Menu send is the variable passed from the experimrnt*/
			if (menusend != "") {
				loadMenu();
			}
		}

		//The function is used to load the experiment swf in the proper position in the template
		public function setCenterSWFPosition(object:Object) {
			if (themeName == "olab") {
				//for the Theme olab
				object.x = 23;
				object.y = 86;
			} else if (themeName=="olabSimulation") {
				//for the theme olab simualator
				if (object is MovieClip) {
					object.x = 243;
					object.y = 78;
					object.scaleX = .91;
					object.scaleY = .91;
				} else if (stageall.Exp_Content) {
					stageall.Exp_Content.x = 242.3;
					stageall.Exp_Content.y = 77;
					stageall.Menu_Content1.x = 18;
					stageall.Menu_Content1.y = 77;
				}
			} else if (themeName=="vlabAnimation") {
				
				object.x = 18;
				object.y = 140;
			} else if (themeName=="Classic") {
				if (stageall.Exp_Content) {
					stageall.Exp_Content.x = 17.5;
					stageall.Exp_Content.y = 87;
					stageall.Menu_Content2.x = stageall.Menu_Content1.x = 603.2;
					stageall.Menu_Content1.y = 108;
					stageall.Menu_Content2.y = 423.5;
				}
			} else if (themeName=="olab_new") {
				frame.scaleX = .78;
				frame.scaleY = .78;
				object.scaleX = .78;
				object.scaleY = .78;
				object.x = 25;
				object.y = 58;
			}

			themeSettings();
			return object;
		}
		public function themeSettings() {
			if (frame.swfFile.FullFrame) {
				if (frame.swfFile.FullFrame.FullScreenButton) {
					frame.swfFile.FullFrame.FullScreenButton.addEventListener(MouseEvent.CLICK, goFullScreen);
				}
				if (frame.swfFile.FullFrame.ScreenShot) {
					frame.swfFile.FullFrame.ScreenShot.addEventListener(MouseEvent.CLICK, saveScreenShot);
				}
				if (frame.swfFile.FullFrame.HomeButton) {
					frame.swfFile.FullFrame.HomeButton.addEventListener(MouseEvent.CLICK,stageall.goHome);
				}
			} else if (frame.swfFile.FullScreenButton) {
				frame.swfFile.FullScreenButton.addEventListener(MouseEvent.CLICK, goFullScreen);
				frame.swfFile.ScreenShot.addEventListener(MouseEvent.CLICK, saveScreenShot);
			}
		}

		private function goFullScreen(evt:MouseEvent):void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
				if (evt.target is MovieClip) {
					evt.target.gotoAndStop(3);
				}
			} else {
				if (evt.target is MovieClip) {
					evt.target.gotoAndStop(1);
				}
				stage.displayState = StageDisplayState.NORMAL;
			}
		}

		//Function for loading the menu for the corresponding simulator
		private function loadMenu() {
			if (themeName == "olabSimulation") {
				menupath = "../../../Common/Templates/menu/vertical_menu.swf";
				menu = loadnewSWF(menupath);
				menu.x = 20;
				menu.y = 80;
				menu.scaleX = .74;
				menu.scaleY = .74;
			}
			addChild(menu);
		}
		public function unloadSWF() {
			newSWF.unloadSWF();
		}
		//loading new SWF
		public function loadnewSWF(swfpath:String,B:Boolean=false):MovieClip {
			newSWF = new loadSWF(swfpath,preloaderpath,stageall,B);
			return newSWF;
		}

		//loading new XML
		public function loadnewXML(XMLurl:String):MovieClip {
			newXML = new loadXML(XMLurl,stageall);
			return newXML;
		}

		//Setting position for a movieclip

		public function setposition(object:Object,Xval:Number,Yval:Number,Width:Number=10,Height:Number=20) {
			object.x = Xval;
			object.y = Yval;
			object.width = Width;
			object.height = Height;
			return object;
		}
		//To save the screen shot of the experiment.

		private function saveScreenShot(evt:MouseEvent):void {
			var jpgSource:BitmapData = new BitmapData(stage.stageWidth,stage.stageHeight);
			jpgSource.draw(stage.root);
			var file:FileReference = new FileReference();
			var jpgEncoder:JPGEncoder = new JPGEncoder(80);
			file.save(jpgEncoder.encode(jpgSource), "image-"+Math.random()+".jpg");
		}


		//function for making the label
		public function makeLabel(x:Number, y:Number, txt:String,width1:Number=200,height1:Number=50,labeltype:String="normal",fontSize:Number=0):Label {
			var label1:Label=new Label();
			var newFormat:TextFormat;
			label1.move(x,y);
			label1.setSize(width1,height1);
			label1.text = txt;
			if (labeltype == "heading") {
				if (fontSize == 0) {
					fontSize = 22;
				}
				newFormat = Format("Arial",fontSize,"0x626262",true,true);
				label1.setStyle("textFormat",newFormat);
			} else if (labeltype=="normal") {
				if (fontSize == 0) {
					fontSize = 18;
				}
				newFormat = Format("Arial",fontSize,"0x626262",true);
				label1.setStyle("textFormat",newFormat);
			}
			return label1;
		}
		//Function for making the label
		public function makeSlider(x:Number, y:Number, min:Number, max:Number,Sliderwidth:Number,height:Number,txt:String,interval:Number=1,valuewidth:Number=0):Slider {
			var vs:Slider=new Slider();
			var newFormat:TextFormat;
			var newFormat1:TextFormat;
			var newFormat2:TextFormat;
			newFormat = Format("Arial",14,"0xB7B7B7");
			newFormat1 = Format("Arial",12,"0x626262",true);
			newFormat2 = Format("Arial",12,"0x626262",true);
			var slidervalue:Label=new Label();
			var valuetext:TextField=new TextField();
			var lab1:TextField=new TextField();
			var lab2:TextField=new TextField();
			var lab3:TextField=new TextField();
			vs.move(x,y);
			vs.liveDragging = true;
			valuetext.defaultTextFormat = newFormat1;
			lab1.defaultTextFormat = newFormat;
			lab2.defaultTextFormat = newFormat;
			lab3.defaultTextFormat = newFormat;
			
			slidervalue.setStyle("textFormat",newFormat2);
			//set size of slider
			vs.setSize(Sliderwidth,height);
			//setting the positon of the Label
			valuetext.x = valuetext.x - 10;
			lab1.autoSize = lab2.autoSize = lab3.autoSize = valuetext.autoSize = TextFieldAutoSize.LEFT;
			slidervalue.autoSize = TextFieldAutoSize.LEFT;
			valuetext.text = txt;
			valuetext.y = 0 - valuetext.height;
			slidervalue.x = valuetext.x + valuetext.width + 5;

			slidervalue.y = valuetext.y;
			slidervalue.text = String(min);
			lab1.x = lab1.x - 5;
			lab2.x=(vs.width/2)-10;
			lab3.x = vs.width - 10;
			//setting the width and height of the label for the first middle and the last value
			
			slidervalue.selectable = valuetext.selectable = lab3.selectable = lab2.selectable = lab1.selectable = false;
			lab1.text = String(min);
			lab2.text=String(((max+min)/2).toFixed(2));
			lab3.text = String(max);
			vs.minimum = min;
			vs.maximum = max;
			vs.snapInterval = interval;
			vs.addChild(lab1);
			vs.addChild(lab2);
			vs.addChild(lab3);
			vs.addChild(valuetext);
			vs.addChild(slidervalue);
			vs.setChildIndex(lab1,1);
			vs.setChildIndex(lab2,2);
			vs.setChildIndex(lab3,3);
			vs.setChildIndex(slidervalue,4);
			vs.setChildIndex(valuetext,5);
			vs.useHandCursor = true;
			vs.buttonMode = true;
			vs.addEventListener(SliderEvent.CHANGE, sliderChangedvalue);
			return vs;
		}

		//function for changing the slider value
		function sliderChangedvalue(e:SliderEvent):void {
			sliderchange(e.target,e.target.value);
		}
		//Function for changing the silder value at the label
		public function sliderchange(slider:Object,slidervalue:Number) {
			slider.getChildAt(4).text = slidervalue;
		}
		//Function for Formating the text
		public function Format(Font:String="Arial",size:Number=12,color:String="0x000000",bold:Boolean=false,underline:Boolean=false):TextFormat {
			var newFormat:TextFormat = new TextFormat();
			newFormat.align = TextFormatAlign.LEFT;
			newFormat.font = Font;
			newFormat.size = size;
			newFormat.bold = bold;
			newFormat.color = color;
			newFormat.underline = underline;
			return newFormat;
		}
		//Function to load the event of the frame
		//publicfunction loadActionEvent(sceneArray:Array,runningSWF:Object)
		public function loadActionEvent(runningSWF:Object) {
			var scenesAndFrames:loadXmlData=new loadXmlData();
			var sceneArray:Array = scenesAndFrames.getSceneAndFrame(runningSWF);
			frame.swfFile.FullFrame.actionMC.forwardButton.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){forwardButtonClicked(evt,runningSWF)});
			frame.swfFile.FullFrame.actionMC.backButton.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){backButtonClicked(evt,runningSWF)});
			frame.swfFile.FullFrame.actionMC.pauseButton.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){pauseButtonClicked(evt,runningSWF)});
			frame.swfFile.FullFrame.actionMC.playButton.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playButtonClicked(evt,runningSWF)});
			scenesValues = sceneArray;
		}
		///event function for bookmark button.......calling from the swf file....
		public function bookmarkButtonClicked(evt:MouseEvent,object:Object) {
			if (bookclips.length > 0) {
				object.removeChild(bookclips[bookclips.length-1]);
				bookclips=new Array();
				object.removeEventListener(Event.ENTER_FRAME,movieload);
			} else {
				loadBookmark(object);
				object.addEventListener(Event.ENTER_FRAME,movieload);
			}
		}
		function loadBookmark(mainSWF:Object) {
			//passing from the index file -library........
			bookmark = stageall.bookmark;
			var scrollPanebg:MovieClip=new MovieClip();
			mainSWF.addChild(scrollPanebg);
			var bookMc:MovieClip=new MovieClip();
			//
			var tooltipMC:Class = getDefinitionByName("toolTip") as Class;
			var tooltipmsg:MovieClip = new tooltipMC() as MovieClip;
			//
			var scrollPane:ScrollPane=new ScrollPane();
			scrollPanebg.addChild(scrollPane);
			scrollPanebg.graphics.beginFill(0xFFFFFF,0);
			scrollPanebg.graphics.drawRect(-6,-6,157,124);
			scrollPane.source = bookMc;
			mainSWF.addChild(tooltipmsg);
			tooltipmsg.visible = false;
			scrollPanebg.x = frame.swfFile.FullFrame.actionMC.x + frame.swfFile.FullFrame.x + frame.swfFile.FullFrame.actionMC.bookmarkButton.x - frame.swfFile.FullFrame.actionMC.bookmarkButton.width;
			scrollPanebg.y = frame.swfFile.FullFrame.actionMC.y + frame.swfFile.FullFrame.y - frame.swfFile.FullFrame.actionMC.height - frame.swfFile.FullFrame.actionMC.bookmarkButton.height;
			var xpos = 10;
			var ypos = 10;
			for (var h=0; h<bookmark.length; h++) {
				var mvclip:MovieClip=new MovieClip();
				var sceneClass:Class = getDefinitionByName(bookmark[h][3]) as Class;
				var mvclips:MovieClip=new sceneClass();
				mvclips.alpha = 0;
				mvclips.buttonMode = true;
				mvclip.addChild(mvclips);
				mvclips.x = mvclip.x + xpos + 15;
				mvclips.y = mvclip.y + ypos + 15;
				xpos = xpos + mvclips.width + 5;
				if ((h+1)%3==0) {
					ypos = ypos + mvclips.height + 5;
					xpos = 10;
				}
				//'ClipIndex' is the property given for movieclips.........
				mvclips.ClipIndex = h;
				bookclips.push(mvclips);
				bookMc.addChild(mvclip);
				////
				mvclips.addEventListener(MouseEvent.ROLL_OVER,function (evt:MouseEvent){showtooltip(evt,tooltipmsg,mainSWF,mvclips)});
				mvclips.addEventListener(MouseEvent.CLICK,function (evt:MouseEvent){clicking(evt,bookmark,mainSWF,tooltipmsg)});
				mvclips.addEventListener(MouseEvent.MOUSE_MOVE,function (evt:MouseEvent){movemsgs(evt,mainSWF,mvclips,tooltipmsg)});
				mvclips.addEventListener(MouseEvent.ROLL_OUT,function (evt:MouseEvent){rollout(evt,tooltipmsg)});
				///
			}
			bookMc.graphics.drawRect(0,0,130,bookMc.height);
			scrollPane.setSize(bookMc.width+15,110);
			scrollPane.update();
			bookclips.push(scrollPanebg);
			///////
			scrollPanebg.addEventListener(MouseEvent.ROLL_OUT,function (evt:MouseEvent){scrollout(evt,scrollPanebg,scrollPane,mainSWF)});
			/////
		}
		////loading all scene- clip with alpha effect.........
		function movieload(e:Event) {
			if (bookclips.length > 0) {
				if (bookclips[0].alpha >= 1) {
					bookclips.splice(0,1);
					if ((bookclips.length-1)==0) {
						e.target.removeEventListener(Event.ENTER_FRAME,movieload);
					}
				} else {
					bookclips[0].alpha +=  .5;
				}
			} else {
				e.target.removeEventListener(Event.ENTER_FRAME,movieload);
			}
		}
		//function for showing the tooltip......
		function showtooltip(evt:MouseEvent,tooltipmsg:MovieClip,mainSWF:Object,mv:Object) {
			tooltipmsg.visible = true;
			tooltipmsg.scenename.text = bookmark[evt.target.ClipIndex][2];
			tooltipmsg.scenename.autoSize = TextFieldAutoSize.LEFT;
			tooltipmsg.x = mainSWF.mouseX;
			tooltipmsg.y = mainSWF.mouseY;
		}
		//showing tooltip with mouse move.....
		function movemsgs(e:MouseEvent,mainSWF:Object,mv:MovieClip,tooltipmsg:Object) {
			tooltipmsg.visible = true;
			tooltipmsg.x = mainSWF.mouseX;
			tooltipmsg.y = mainSWF.mouseY;
		}
		function rollout(evt:MouseEvent,tooltipmsg:Object) {
			tooltipmsg.visible = false;
		}
		////scene selection .......
		function clicking(evt:MouseEvent,bookmark:Array,mainSWF:Object,tooltipmsg:Object) {
			tooltipmsg.visible = false;
			var echoFileNameArray = mainSWF.swfFile.loaderInfo.url.split("/");
			var thisSWF=echoFileNameArray[(echoFileNameArray.length)-1];
			if (bookmark[evt.target.ClipIndex][0] == thisSWF) {
				mainSWF.swfFile.gotoAndPlay(1,bookmark[evt.target.ClipIndex][1]);
			} else {
				var loadNewSwf:MovieClip=new MovieClip();
				loadNewSwf = new bookmarkLoad(stageall,evt.target.ClipIndex,mainSWF,bookmark);
				return loadNewSwf;
			}
		}
		////scrolpane rol_out function....
		function scrollout(evt:MouseEvent,bg:Object,scrollPane:Object,mainSWF:Object) {
			bg.visible = false;
			mainSWF.removeEventListener(Event.ENTER_FRAME,movieload);
			mainSWF.removeChild(bg);
			bg.removeChild(scrollPane);
			bookclips=new Array();
		}
		//Event function for forward button
		function forwardButtonClicked(evt:MouseEvent,runningSWF:Object) {
			var currentscene = runningSWF.swfFile.currentScene.name;
			var currentframe = runningSWF.swfFile.currentFrame;
			for (var i=0; i<scenesValues[currentscene].length; i++) {
				if ((currentframe>scenesValues[currentscene][i]) && (currentframe<scenesValues[currentscene][i+1])) {
					runningSWF.swfFile.gotoAndPlay(scenesValues[currentscene][i+1]);
					break;
				} else if (i==(scenesValues[currentscene].length-1)) {
					runningSWF.swfFile.nextScene();
					break;
				}
			}
		}
		//Event function for forward button
		function backButtonClicked(evt:MouseEvent,runningSWF:Object) {
			var currentscene = runningSWF.swfFile.currentScene.name;
			var currentframe = runningSWF.swfFile.currentFrame;
			for (var i=scenesValues[currentscene].length; i>=0; i--) {
				if (i == 0) {
					runningSWF.swfFile.prevScene();
				} else if ((currentframe>scenesValues[currentscene][i]) ) {
					runningSWF.swfFile.gotoAndPlay(scenesValues[currentscene][i-1]);
					break;
				}
			}
		}
		//Pause Function
		public function pauseButtonClicked(evt:MouseEvent,runningSWF:Object) {
			var ct:Color = new Color();
			ct.setTint(0xFF0000, 0.3);
			ct.setTint(0xFF0000, 0);
			frame.swfFile.FullFrame.actionMC.playButton.transform.colorTransform = ct;
			ct.setTint(0xFF0000, 0.3);
			evt.target.transform.colorTransform = ct;
			for (var i:int = 0; i < runningSWF.swfFile.numChildren; i++) {
				if (runningSWF.swfFile.getChildAt(i) is MovieClip) {
					for (var j:int=0; j<runningSWF.swfFile.getChildAt(i).numChildren; j++) {
						if (runningSWF.swfFile.getChildAt(i).getChildAt(j) is MovieClip) {
							for (var k:int=0; k<runningSWF.swfFile.getChildAt(i).getChildAt(j).numChildren; k++) {
								if (runningSWF.swfFile.getChildAt(i).getChildAt(j).getChildAt(k) is MovieClip) {
									MovieClip(runningSWF.swfFile.getChildAt(i).getChildAt(j).getChildAt(k)).stop();
								}
							}
							MovieClip(runningSWF.swfFile.getChildAt(i).getChildAt(j)).stop();
						}
					}
					MovieClip(runningSWF.swfFile.getChildAt(i)).stop();
				}
			}
			runningSWF.swfFile.stop();
		}
		//Play Function
		public function playButtonClicked(evt:MouseEvent,runningSWF:Object) {
			var ct:Color = new Color();
			ct.setTint(0xFF0000, 0.3);
			ct.setTint(0xFF0000, 0);
			frame.swfFile.FullFrame.actionMC.pauseButton.transform.colorTransform = ct;
			ct.setTint(0xFF0000, 0.3);
			evt.target.transform.colorTransform = ct;
			for (var i:int = 0; i < runningSWF.swfFile.numChildren; i++) {
				if (runningSWF.swfFile.getChildAt(i) is MovieClip) {
					for (var j:int=0; j<runningSWF.swfFile.getChildAt(i).numChildren; j++) {
						if (runningSWF.swfFile.getChildAt(i).getChildAt(j) is MovieClip) {
							for (var k:int=0; k<runningSWF.swfFile.getChildAt(i).getChildAt(j).numChildren; k++) {
								if (runningSWF.swfFile.getChildAt(i).getChildAt(j).getChildAt(k) is MovieClip) {
									MovieClip(runningSWF.swfFile.getChildAt(i).getChildAt(j).getChildAt(k)).play();
								}
							}
							MovieClip(runningSWF.swfFile.getChildAt(i).getChildAt(j)).play();
						}
					}
					MovieClip(runningSWF.swfFile.getChildAt(i)).play();
				}
			}
			runningSWF.swfFile.play();
		}

		public function loadXMLData(centerSWF:Object,XMLdata:XML) {
			////For dispaly swf file name,scene name , and frame number
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			if (previousSwf != "") {
				// to remove previous Event Listener
				framesandlabels.removeEnterFrame(previousSwf);
			}
			///////

			previousSwf = centerSWF;
			framesandlabels.loadData(centerSWF,XMLdata,frame.swfFile.FullFrame.xmlText);
		}
		////For dispaly swf file name,scene name , and frame number

		public function keyDownHandler(e:KeyboardEvent) {
			if (e.ctrlKey) {
				if (e.keyCode == 192) {
					key++;
					if (key % 2 == 1) {
						echotxt.visible = true;
						addEventListener(Event.ENTER_FRAME,updateframe);
					} else {
						echotxt.visible = false;
						removeEventListener(Event.ENTER_FRAME,updateframe);
					}
				}
			}
		}
		////For dispaly swf file name,scene name , and frame number
		public function updateframe(e:Event) {
			if (newSWF.swfFile.loaderInfo != null) {
				echoFileNameArray = newSWF.swfFile.loaderInfo.url.split("/");
				thisSWF=echoFileNameArray[(echoFileNameArray.length)-1];
				echotxt.text = thisSWF + " , " + newSWF.swfFile.currentScene.name + " , " + newSWF.swfFile.currentFrame;
				echotxt.setTextFormat(echoFormat);
			}
		}



	}//End Class
}//End Package