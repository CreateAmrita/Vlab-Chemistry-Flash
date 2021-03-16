/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


/* Class for loading an external XML Data */
package common{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.text.TextFieldAutoSize;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;




	public class loadSubTitles{
		private var xmlData:XML=new XML  ;
		private var Stage_obj:Object;
		private var Template:Object;
		private var txt:TextField;
		public var intervalID:uint;
		private var debug_info_txt:TextField = new TextField();
		private var debug_txt:Boolean=false;
		var headingStr="";

		public function loadSubTitles(Stage1:Object) {
			Stage_obj=Stage1;
		}
		public function loadXml(Url:String,Temp:Object) {
			Template=Temp;
			if (Template) {
				var xmlLoader:URLLoader=new URLLoader  ;
				xmlLoader.load(new URLRequest(Url));
				xmlLoader.addEventListener(Event.COMPLETE,showXML);
			}
		}
		private function showXML(e:Event) {
			//before loading subtitle xml, template must be loaded....
			if (Template.FullFrame) {
				if (Template.FullFrame.xmlText) {
					txt=Template.FullFrame.xmlText;
				} else {
					trace("Template, subtitles text box not found...");
				}
			} else {
				trace("Template, subtitles text box not found...");
			}
			xmlData=new XML(e.target.data);
			Stage_obj.parent.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			Stage_obj.SubTitlesXMLLoaded();
		}

		private function keyDownHandler(e:KeyboardEvent) {
			if (e.ctrlKey) {
				if (e.keyCode==192) {
					if (!debug_txt) {
						debug_info_txt.autoSize=TextFieldAutoSize.LEFT;
						debug_info_txt.background=true;
						debug_info_txt.wordWrap=true;
						debug_info_txt.width=500;
						Stage_obj.addChild(debug_info_txt);
						debug_txt=true;
					} else {
						Stage_obj.removeChild(debug_info_txt);
						debug_txt=false;
					}
				}
			}
		}


		public function showTitle(currentscene:String,currentlabel:String) {
			
			loadXmlText(xmlData.SCENE.(@ID==currentscene).TEXT.(@ID==currentlabel).TEXTVALUE.text());
						
		}			
			//strings getting from xml
		public function showStringFromXml(currentscene:String,currentlabel:String)
		{
			headingStr=xmlData.SCENE.(@ID==currentscene).TEXT.(@ID==currentlabel).TEXTVALUE.text()
			return(headingStr);
		}
		
		public function clearTitle() {
			if (intervalID) {
				clearInterval(intervalID);
			}
			txt.text="";
			txt.alpha=0;
		}

		//Function for lading XML text to the text fiel of the frame
		private function loadXmlText(XMLtext) {
			
			txt.text=XMLtext;
			
			//getting the data from the XML
			if (XMLtext=="notext") {
				txt.text="";
			} else if (XMLtext!="") {
				//Setting alpha of the text to 0 for making a fide in effect;
				txt.alpha=0;
				debug_info_txt.text=String(debug_info_txt);
				if (debug_info_txt) {
					var echoFileNameArray:Array= new Array();
					echoFileNameArray=Stage_obj.mainSWF.swfFile.loaderInfo.url.split("/");
					var currentSwf=echoFileNameArray[(echoFileNameArray.length)-1];
					debug_info_txt.text=currentSwf+" , "+Stage_obj.mainSWF.swfFile.currentScene.name;
				}
				//puting the text value
				txt.text=XMLtext;
				if (String(txt.text).indexOf("[cml]")!=-1||String(txt.text).indexOf("[sup]")!=-1||String(txt.text).indexOf("[sub]")!=-1) {
					CMLCode(txt,txt.text);
				}
				if (intervalID) {
					clearInterval(intervalID);
				}
				//function for fade in effect
				intervalID=setInterval(FadeTextIn,5,10,txt);

			}

		}
		
		//Function for displaying subtitle-language translation...
		public function changeSubTitles(xmlTextField){
			xmlTextField.text = txt.text;
		}
		
				
		//Function for fade in the text
		public function FadeTextIn(targetin_alpha:Number,fade_object:TextField) {
			var fadeinspeed=1;
			if (fade_object.alpha<targetin_alpha) {
				var TempAlpha=fade_object.alpha+.1;
				fade_object.alpha=TempAlpha;
			}
			if (fade_object.alpha>=targetin_alpha) {
				fade_object.alpha=10;
				if (intervalID) {
					clearInterval(intervalID);
				}
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
			embeddedFont=embeddedFontsArray[1];
			embeddedFont1=embeddedFontsArray[0];
			var font_sub:TextFormat=new TextFormat  ;
			font_sub.font=embeddedFont.fontName;
			font_sub.size=25;
			var font_sup:TextFormat=new TextFormat  ;
			font_sup.font=embeddedFont1.fontName;
			font_sup.size=25;
			var cml_array:Array=new Array  ;
			var cml_array1:Array=new Array  ;
			var sup_array1:Array=new Array  ;
			var sup_array2:Array=new Array  ;
			var sub_array1:Array=new Array  ;
			var sub_array2:Array=new Array  ;
			var j=0;
			var k=6;
			var i;
			for (i=0; i<formula.length; i++) {
				//get [cml] and [/cml] from text
				var cml_Substring=formula.substring(i,i+5);
				var cml_Substring1=formula.substring(i,i+6);
				//get start index of after [cml].
				if (cml_Substring=="[cml]") {
					cml_array.push(i-j);
					j=k+5;
				} else if (cml_Substring1=="[/cml]") {
					cml_array1.push(i-k);
					k=j+6;
				} else if (cml_Substring=="[sup]") {
					sup_array1.push(i-j);
					j=k+5;
				} else if (cml_Substring1=="[/sup]") {
					sup_array2.push(i-k+1);
					k=j+6;
				} else if (cml_Substring=="[sub]") {
					sub_array1.push(i-j);
					j=k+5;
				} else if (cml_Substring1=="[/sub]") {
					sub_array2.push(i-k+1);
					k=j+6;
				}

			}

			//*****************SUPERSCRIPT code*********************//
			for (i=0; i<sup_array1.length; i++) {
				qtext.setTextFormat(font_sup,sup_array1[i],sup_array2[i]);
			}
			//*****************SUBSCRIPT code*********************//
			for (i=0; i<sub_array1.length; i++) {
				qtext.setTextFormat(font_sub,sub_array1[i],sub_array2[i]);
			}
			//*****************CML code*********************//
			var flag;

			for (i=0; i<cml_array.length; i++) {
				//set flag : to detect substring is first number or not .
				flag=0;
				for (var t=cml_array[i]; t<=cml_array1[i]; t++) {

					var cml_mySubstring=qtext.text.substring(t,t+1);
					var cml_mySubstring1=qtext.text.substring(t-1,t);
					var koko=cml_mySubstring;


					if (! isNaN(cml_mySubstring)) {

						if (cml_mySubstring1==".") {
							flag=0;
						}
						if (flag==1) {
							qtext.setTextFormat(font_sub,t,t+1);
						}

					} else if (isNaN(cml_mySubstring)) {
						//substring is "+" or "-"
						if (cml_mySubstring=="+"||cml_mySubstring=="-") {
							qtext.setTextFormat(font_sup,t,t+1);
							var s1=t-1;
							var s2=t;
							var cml_mySubstring3:String=qtext.text.substring(s1,s2);

							//substring before substring is number
							if (! isNaN(cml_mySubstring1)) {
								qtext.setTextFormat(font_sup,t-1,t);

							}
						}
						flag=1;

					}
				}
			}
		}

	}//CLASS END
}//PCAKAGE END