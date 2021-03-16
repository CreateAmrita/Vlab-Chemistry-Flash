/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package Fonts{
	////////////
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	////////
	public class LoadSharedFont {
		public var StageMc:MovieClip;
		private var fontLoader:Loader=new Loader  ;
		private var fontLoaderInfo:LoaderInfo=fontLoader.contentLoaderInfo;
		public var embeddedFonts:Array=new Array  ;
		///To load external font swf file..
		public function LoadSharedFont(rootMc:MovieClip,Mc:String) {
			StageMc=rootMc;
			fontLoaderInfo.addEventListener(Event.COMPLETE,fontReady);
			fontLoader.load(new URLRequest(Mc));
		}
		private function fontReady(e:Event):void {
			var info:LoaderInfo=e.currentTarget as LoaderInfo;
			var loader:Loader=info.content as Loader;
			embeddedFonts=Font.enumerateFonts(false);
			// This function will call back....
			StageMc.loadFontfontReady();
		}
		// For creating new text field.. with embedded font..
		public function NewTextFieldEmbeddedFont(t:String,c:uint,s:uint,FontName:String,fontStyle:String):TextField {
			var Num=0;
			for (var i=0; i<embeddedFonts.length; i++) {
				if (embeddedFonts[i]["fontName"]==FontName&&embeddedFonts[i]["fontStyle"]==fontStyle) {
					Num=i;
					break;
				} else if (i==embeddedFonts.length-1) {
					c=0xFF0000;
				}
			}
			//////
			var fo:TextFormat=new TextFormat  ;
			fo.font=embeddedFonts[Num].fontName;
			fo.color=c;
			fo.size=s;
			if (fontStyle=="bold") {
				fo.bold=true;
			} else {
				fo.bold=false;
			}
			///// Creating new text field..
			var tf:TextField=new TextField  ;
			tf.defaultTextFormat=fo;
			tf.embedFonts=true;
			tf.antiAliasType=AntiAliasType.ADVANCED;
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.text=t;
			return tf;
		}
		public function EmbeddedFontFormat(FontName:String,fontStyle:String):TextFormat {
			var Num=0;
			var fo:TextFormat=new TextFormat  ;
			for (var i=0; i<embeddedFonts.length; i++) {
				if (embeddedFonts[i]["fontName"]==FontName&&embeddedFonts[i]["fontStyle"]==fontStyle) {
					Num=i;
					break;
				} else if (i==embeddedFonts.length-1) {
					var c=0xFF0000;
					fo.color=c;
				}
			}
			fo.font=embeddedFonts[Num].fontName;
			///
			if (fontStyle=="bold") {
				fo.bold=true;
			} else {
				fo.bold=false;
			}
			return fo;
		}
	}
}