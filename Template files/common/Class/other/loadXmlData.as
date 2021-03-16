/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


/* Class for loading an external XML Data */
package other{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.text.TextFormat;
	public class loadXmlData extends MovieClip {
		public var xmlData:XML=new XML  ;
		//Arry used for the action button
		var scenesAndFrames:Array=new Array();
		var scenesAndFramesAndLabel:Array=new Array();

		var scene:Array=[];
		var labelarray:Array=[];
		var sceneName:Array=[];
		//var labelNameandFrame:Array=[];
		var sceneFrame:Array=[];
		var labelFrame:Array=[];
		var totalscene1:Number=0;
		var txt:TextField;
		private var intervalID:uint;
		//labelNameandFrame.push(new(Array));
		var currentSceneAndFrame:Array=new Array();
		var centerswf:Object=new Object();
		public function removeEnterFrame(Obj:Object) {
			if (Obj) {
				if (Obj.swfFile) {
					if (Obj.swfFile.hasEventListener(Event.ENTER_FRAME)) {
						Obj.swfFile.removeEventListener(Event.ENTER_FRAME,getFrameplaying);
					}
				}
			}
		}
		public function loadData(centerswf1:Object,Xml:XML,text1:TextField,flag:Boolean=false) {
			centerswf=centerswf1;
			if (! flag) {
				txt=text1;
				xmlData=Xml;
				centerswf.swfFile.addEventListener(Event.ENTER_FRAME,getFrameplaying);
			}
			//This is used to get all the scenes and frames and label of the current swf
			for (var i:uint = 0; i < centerswf.swfFile.scenes.length; i++) {//getting the totla number of scenes
				var scene:Scene=centerswf.swfFile.scenes[i];//assigning each values to a variable
				sceneName.push(scene.name);//collecting all the scene values
				sceneFrame.push(scene.numFrames);//collecting all toltal number of scene of a scene
				//trace("scene: " + scene.name + "  frames: " + scene.numFrames);// + " frames"+ " Labels :"+scene.labels);
				for (var j:uint=0; j<scene.labels.length; j++) {//getting the labels of the scene
					//trace("scene: " + scene.name + "  frames: " + scene.numFrames+ " LabelName:"+scene.labels[j].name+"  LabelFrame:"+scene.labels[j].frame);
					labelarray.push(scene.labels[j].name);//collecting the loaded label of a scene
					labelFrame[scene.labels[j].name]=new Array();//making the label frame a 2D array to accomodate the frame number of the current frame
					if (i==0) {//if it is first scene
						labelFrame[scene.labels[j].name].push(scene.labels[j].frame);//collecting the frame number of the label
					} else {
						//if it is not the first scene add all the frame total of all the scene till the current scene
						totalscene1=0;
						for (var w=0; w<i; w++) {
							totalscene1=totalscene1+sceneFrame[w];
						}
						totalscene1=totalscene1+scene.labels[j].frame;
						labelFrame[scene.labels[j].name].push(totalscene1);

					}
				}

			}
			for (var k=0; k<sceneName.length; k++) {
				scenesAndFrames[sceneName[k]]=new Array();//getting the scene and frame of the label
				scenesAndFramesAndLabel[sceneName[k]]=new Array();//making a 3d array for collecting the the scene,frame and label of the swf
				for (var l=0; l<labelarray.length; l++) {
					var array:Array=labelarray[l].split("_");//spliting the label name for finding the label for corresponding scene
					if (array[0]==sceneName[k]) {//checking the label is of the same scene
						scenesAndFrames[sceneName[k]].push(labelFrame[labelarray[l]]);//making the frame number of the label as the 2 nd dimension of the array
						//for (var m=0; m< labelFrame[labelarray[l]].length; m++) {
						scenesAndFramesAndLabel[sceneName[k]][labelFrame[labelarray[l]]]=new Array();//making 3D array
						scenesAndFramesAndLabel[sceneName[k]][labelFrame[labelarray[l]]].push(labelarray[l]);//making the label name as the 3 rd dimension of the array

					}
				}
			}

			//return (currentSceneAndFrame);
		}

		//Enter frmae function
		private function getFrameplaying(evt:Event) {
			var currentscene:String=centerswf.swfFile.currentScene.name;//getting the current scene name
			var currentframe:String=centerswf.swfFile.currentFrame;//getting the current frame number

			currentSceneAndFrame=new Array();
			currentSceneAndFrame.push(currentscene);
			currentSceneAndFrame.push(currentframe);
			/*trace("currentscene:"+currentscene);
			trace("currentframe="+currentframe);*/
			//getting the label name of the current scene and cureent frame if its doest exist an error occure for avoiding that try catch is used
			try {
				var labelnameval:String=scenesAndFramesAndLabel[currentscene][currentframe][0];
				loadXmlText(currentscene,labelnameval);
			} catch (evt:Error) {
				//trace(evt.target.name);
			}

		}
		public function getSceneAndFrame(centerswfval:Object):Array {
			loadData(centerswfval,null,null,true);
			return (scenesAndFrames);
		}

		//Function for lading XML text to the text fiel of the frame
		public function loadXmlText(currentscene:String,currentlabel:String) {
			//getting the data from the XML
			var XMLtext:String=xmlData.SCENE.(@ID==currentscene).TEXT.(@ID==currentlabel).TEXTVALUE.text();
			//if XMLTExt is not null
			if (XMLtext!="") {
				//Setting alpha of the text to 0 for making a fide in effect;
				txt.alpha=0;
				//puting the text value
				txt.text=XMLtext;
				if (String(txt.text).indexOf("[cml]")!=-1 || String(txt.text).indexOf("[sup]")!=-1 || String(txt.text).indexOf("[sub]")!=-1) {
					CMLCode(txt,txt.text);
				}
				//checkForFormula(txt.text,txt)
				clearInterval(intervalID);
				//function for fade in effect
				intervalID=setInterval(FadeTextIn,5,10,txt);

			}
			if (XMLtext=="notext") {
				txt.text="";
			}
		}
		//Function for fade in the text
		public function FadeTextIn(targetin_alpha:Number,fade_object:TextField) {
			var fadeinspeed=1;

			if (fade_object.alpha<targetin_alpha) {
				//var TempAlpha = Math.round(fade_object.alpha + 1);
				var TempAlpha=fade_object.alpha+.1;
				//trace("TempAlpha: " + TempAlpha);
				fade_object.alpha=TempAlpha;
			}
			if (fade_object.alpha>=targetin_alpha) {

				fade_object.alpha=10;
				clearInterval(intervalID);
			}

		}
		
		function CMLCode(qtext,formula) {
			qtext.text=formula.split("[cml]").join("").split("[/cml]").join("").split("[sup]").join("").split("[/sup]").join("").split("[sub]").join("").split("[/sub]").join("");
			var embeddedFont:Font=null;
			var embeddedFont1:Font=null;
			var embeddedFontClass:Class=getDefinitionByName("GGSubscript") as Class;
			var embeddedFontClass1:Class=getDefinitionByName("GGSuperscript") as Class;
			Font.registerFont(embeddedFontClass);
			Font.registerFont(embeddedFontClass1);
			var embeddedFontsArray:Array=Font.enumerateFonts(false);
			//var embeddedFontsArray:Array=Font.enumerateFonts(false);
			embeddedFont=embeddedFontsArray[1];
			embeddedFont1=embeddedFontsArray[0];
			trace(embeddedFont)
			var font_sub:TextFormat = new TextFormat();
			font_sub.font=embeddedFont.fontName;
			font_sub.size=25
			var font_sup:TextFormat = new TextFormat();
			font_sup.font=embeddedFont1.fontName;			
			font_sup.size=25
	var cml_array:Array = new Array();
	var cml_array1:Array = new Array();
	var sup_array1:Array = new Array();
	var sup_array2:Array = new Array();
	var sub_array1:Array = new Array();
	var sub_array2:Array = new Array();
	var j=0;
	var k=6;
	var i;
	for (i = 0; i<formula.length; i++) {
		//get [cml] and [/cml] from text
		var cml_Substring=formula.substring(i,i+5);
		var cml_Substring1=formula.substring(i,i+6);
		//get start index of after [cml].
		if (cml_Substring=="[cml]") {
			cml_array.push(i-j);
			j=k+5;
		} else if (cml_Substring1 == "[/cml]") {
			cml_array1.push(i-k);
			k=j+6;
		} else if (cml_Substring == "[sup]") {
			sup_array1.push(i-j);
			j=k+5;
		} else if (cml_Substring1 == "[/sup]") {
			sup_array2.push(i-k+1);
			k=j+6;
		} else if (cml_Substring == "[sub]") {
			sub_array1.push(i-j);
			j=k+5;
		} else if (cml_Substring1 == "[/sub]") {
			sub_array2.push(i-k+1);
			k=j+6;
		}

	}

	//*****************SUPERSCRIPT code*********************//
	for (i = 0; i<sup_array1.length; i++) {
		qtext.setTextFormat(font_sup,sup_array1[i],sup_array2[i]);
	}
	//*****************SUBSCRIPT code*********************//
	for (i = 0; i<sub_array1.length; i++) {
		qtext.setTextFormat(font_sub,sub_array1[i],sub_array2[i]);
	}
	//*****************CML code*********************//
	var flag;

	for (i = 0; i<cml_array.length; i++) {
		//set flag : to detect substring is first number or not .
		flag=0;
		for (var t=cml_array[i]; t<=cml_array1[i]; t++) {

			var cml_mySubstring=qtext.text.substring(t,t+1);
			var cml_mySubstring1=qtext.text.substring(t-1,t);
			var koko=cml_mySubstring;


			if (!(isNaN(cml_mySubstring))) {

				if (cml_mySubstring1==".") {
					flag=0;
				}
				if (flag==1) {
					qtext.setTextFormat(font_sub,t,t+1);
				}

			} else if (isNaN(cml_mySubstring)) {
				//substring is "+" or "-"
				if ((cml_mySubstring == "+") || (cml_mySubstring == "-")) {
					qtext.setTextFormat(font_sup,t,t+1);
					var s1=t-1;
					var s2=t;
					var cml_mySubstring3:String=qtext.text.substring(s1,s2);
					trace(cml_mySubstring3);

					//substring before substring is number
					if (!(isNaN((cml_mySubstring1)))) {
						qtext.setTextFormat(font_sup,t-1,t);

					}
				}
				flag=1;

			}
		}
	}
}

		/*public function checkForFormula1(formula, qtext):void {
			trace("subscript"+qtext)
			qtext.text=formula.split("[cml]").join("").split("[/cml]").join("").split("[sup]").join("").split("[/sup]").join("").split("[sub]").join("").split("[/sub]").join("");
			//qtext.size = S;
			qtext.embedFonts=true;
			//qtext.setTextFormat(fontTekton);

			var cml_txt_fmt_large:TextFormat = new TextFormat();
			var embeddedFont:Font=null;
			//cml_txt_fmt_large.size = S;
			//cml_txt_fmt_large.color = C;
			//cml_txt_fmt_large.align = A;
			qtext.setTextFormat(cml_txt_fmt_large);
			var embeddedFontClass:Class=getDefinitionByName("GGSubscript") as Class;
			Font.registerFont(embeddedFontClass);
			var embeddedFontsArray:Array=Font.enumerateFonts(false);
			embeddedFont=embeddedFontsArray[0];
			var font_sub:TextFormat = new TextFormat();
			font_sub.font=embeddedFont.fontName;
			var font_sup:TextFormat = new TextFormat();
			font_sup.font=embeddedFont.fontName;
			var cml_array:Array=[];
			var cml_array1:Array=[];

			var j=0;
			var k=6;
			var cml_Substring:String;
			var cml_Substring1:String;
			var flag;

			var t;
			var s1;

			var s2;
			//trace(formula);
			for (var i = 0; i<formula.length; i++) {
				//get [cml] and [/cml] from text
				cml_Substring=formula.substring(i,i+5);
				cml_Substring1=formula.substring(i,i+6);

				//get start index of after [cml].
				if (cml_Substring=="[cml]") {
					trace(cml_Substring);
					trace("i="+i+"j="+j);
					cml_array.push(i-j);
					//trace(cml_array);
					j=k+5;
				} else if (cml_Substring1 == "[/cml]") {
					cml_array1.push(i-k);
					k=j+6;
				}

			}
			//*****************CML code*********************/
			/*for (i = 0; i<cml_array.length; i++) {
				//set flag : to detect substring is first number or not .
				flag=0;
				for (t=cml_array[i]; t<=cml_array1[i]; t++) {
					var cml_mySubstring=qtext.text.substring(t,t+1);
					var cml_mySubstring1=qtext.text.substring(t-1,t);

					//substring is number
					if (!(isNaN(cml_mySubstring))) {
						if (cml_mySubstring1==".") {
							flag=0;
						}
						if (flag==1) {
							qtext.setTextFormat(font_sup,t,t+1);
						}

					} else if ((isNaN(cml_mySubstring))) {
						trace(cml_mySubstring3);
						//substring is "+" or "-"
						if (cml_mySubstring=="+"||cml_mySubstring=="-") {
							qtext.setTextFormat(font_sup,t,t+1);
							s1=t-1;
							s2=t;
							var cml_mySubstring3:String=qtext.text.substring(s1,s2);


							//substring before substring is number
							if (!(isNaN(cml_mySubstring1))) {
								qtext.setTextFormat(font_sup,t-1,t);
							}
						}
						flag=1;

					}
				}
			}*/
			/***************************************************************/
		//}

	}//CLASS END
}//PCAKAGE END