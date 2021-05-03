stop();

var BioXmlData:XML;
// should define 'XmlPath' in the main file...
var urlRequest:URLRequest=new URLRequest(XmlPath);
var urlLoader:URLLoader = new URLLoader();
urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
urlLoader.load(urlRequest);
/////
function urlLoader_complete(evt:Event):void {
	BioXmlData=new XML(evt.target.data);
	play();
	//trace(BioXmlData)
	// textArea.text = BioXmlData.toXMLString();
}
//////////
function LoadXmlText(Txt,SceneNo:Number,TxtNo:Number) {
	//Txt.text=BioXmlData.child("SCENE")[0];
	for (var Xmli=0; Xmli<BioXmlData.child("SCENE").length(); Xmli++) {
		if (Number(BioXmlData.child("SCENE")[Xmli].attribute("NO"))==SceneNo) {
			//trace(BioXmlData.child("SCENE")[Xmli].attribute("NO"));
			for (var Xmlj=0; Xmlj<BioXmlData.child("SCENE")[Xmli].child("TEXT").length(); Xmlj++) {
				if (Number(BioXmlData.child("SCENE")[Xmli].child("TEXT")[Xmlj].attribute("ID"))==TxtNo) {
					Txt.text=BioXmlData.child("SCENE")[Xmli].child("TEXT")[Xmlj];
					//trace(BioXmlData.child("SCENE")[Xmli].child("TEXT")[Xmlj])
					if (String(Txt.text).indexOf("[cml]")!=-1) {
						checkForFormula(Txt.text,Txt);
					}
					break;
				}
			}
			break;
		}
	}
}

function checkForFormula(formula, qtext):void {
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
	//*****************CML code*********************//
	for (i = 0; i<cml_array.length; i++) {
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
	}
	/***************************************************************/
}