//==================================================================================================================//
//
// Dec.2008 Written by Thomas from 
// www.mindtransplant.com and
// www.demiansinclair.com
// 
//
//
////// Terms and Conditions for uses of this code.
// Code can be used in personal or commercial applications.
// Code is licensed "as is" free of charge.
// Source can not be sold as a source code or as a component. 
// If you integrate it into an application, do as you please.
// You are free to make any changes you feel are appropriate to your applicaiton.
// Feel free to support the flash-community-forums and post any improvements or changes on this code.
//
//==================================================================================================================//
//==================================================< HIERARCHY >==================================================//
//==================================================================================================================//
		/*
		MainTimeline
			- m (this -> MovieClip)
				-- bgr
				-- next_btn
				-- prev_btn
				-- dayRow				// row of DayNames
				-- calendar				// Date Grid contains dynamic Data
					--- month_txt		// displays the month and year
					--- nr_spr
					--- nr_bgr
					--- nr_txt
		*/
//==================================================================================================================//
//==================================================================================================================//

package {
	
    	import flash.text.*;
		import flash.display.*;
		import flash.events.*;
		import flash.geom.Matrix;
		import flash.filters.*;
	
	public class DatePicker extends MovieClip{ 
	
		////////////////////------------< DEFAULT USER VARS >------------////////////////////
		public var language:String = "de";  //  "de" or "en"
		public var style:String = "blue";   //  "blue" or "white"
		////////////////////------------</ DEFAULT USER VARS >------------////////////////////
		
		////////////////////------------< CLASS VARS >------------////////////////////
		private var m = this;
		private var todayDate:Date = new Date();	// contains Date of Today
		private var xDate:Date = new Date();		// contains Date of Today or Date received by setDatum
		private var monthArray_en:Array = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
		private var monthArray_de:Array = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
		private var dayNameArray_en:Array = new Array("Mo","Tu","We","Th","Fr","Sa","Su");
		private var dayNameArray_de:Array = new Array("Mo","Di","Mi","Do","Fr","Sa","So");
		private var daysMonthArray:Array = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
		private var fontColor:uint;
		private var selectDate:String;				// contains the clicked Date
		private var calendar:Sprite;				// container-Sprite for the Date-Grid
		private var mCount:Number;					// month-counter
		private var yCount:Number;					// year-counter
		////////////////////------------</ CLASS VARS >------------////////////////////
		
		
		// Constructor
		public function DatePicker(){
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		//////////----------< defines initial Date. if not set Date equals today >----------////////
		public function setDatum(__d:int,__m:int,__y:int):void{
			xDate.setDate(__d);
			xDate.setMonth(__m-1);
			xDate.setFullYear(__y);
		}
		public function getDatum():String{
			return selectDate;
		}
		
		//////////----------< defines language >----------////////
		public function setLang(st:String):void{
			language = st;  // "en" or "de"
		}
		public function getLang():String{
			return language;
		}
		
		//////////----------< defines UI color >----------////////
		public function setSkin(st:String):void{
			style = st;  // "blue" or "white"
		}
		public function getSkin():String{
			return style;
		}
		
		
		private function init(e:Event):void{
			style == "white" ? fontColor = 0x333333 : fontColor = 0xCCCCCC;
			var bgr:Sprite = m.addChild(drawRadialBackground(240,175));
			
			var next_btn:Sprite = m.addChild(drawArrow(m.width-25,12,0));
			next_btn.buttonMode = true;
			next_btn.addEventListener(MouseEvent.CLICK, onNextClick);
			next_btn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			next_btn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			var prev_btn:Sprite = m.addChild(drawArrow(25,12,180));
			prev_btn.buttonMode = true;
			prev_btn.addEventListener(MouseEvent.CLICK, onPrevClick);
			prev_btn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			prev_btn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			var dayRow:Sprite = m.addChild(drawDayNameRow(5,25));
			drawDateGrid(xDate.getMonth(), xDate.getFullYear());
			
		}
		
		private function drawDayNameRow(__x:Number,__y:Number):Sprite{
			var cont = new Sprite();
			cont.x = __x;
			cont.y = __y;
			//////////------------< Background Rectangle >------------//////////
			var rowColor:uint;
			style == "white" ? rowColor = 0xFFFFFF  : rowColor = 0x000000;
			var nameRow:Sprite = cont.addChild(rect(m.width-15,22,rowColor,0.5));
			//////////------------< Row of DayNames >------------//////////
			for( var i:int = 0; i<7; i++){
				var d_txt:TextField = new TextField();
				language == "de" ? d_txt.text = dayNameArray_de[i] : d_txt.text = dayNameArray_en[i];
				d_txt.width = 30; d_txt.height = 20;
				d_txt.selectable = false;
				d_txt.y = 3;
				d_txt.x = i*32;
				d_txt.setTextFormat(txtFormat("dayNameRow"));
				cont.addChild(d_txt);
			}
			return cont;
		}
		
		private function drawDateGrid(mm:Number, yy:Number):void{
			calendar = new Sprite();
			calendar.x = 5;
			m.addChild(calendar);

			//////////------------< Month + Year Display >------------//////////
			var month_txt:TextField = new TextField();
            language == "de" ? month_txt.text = monthArray_de[mm] + " " + yy : month_txt.text = monthArray_en[mm] + " " + yy;
            month_txt.autoSize = TextFieldAutoSize.CENTER;
			month_txt.y = 5;
			month_txt.x = (m.width/2)-(month_txt.width/2);
			month_txt.setTextFormat(txtFormat("month"));
			calendar.addChild(month_txt);
			
			//////////------------< Rows of DayNumbers >------------//////////
			var daysNr:int = (yy%4 == 0 && mm == 1) ? 29 : daysMonthArray[mm];  //  recognizing leap years
			var myDate:Date = new Date(yy,mm,1);								//  1st of Month(mm)
			// dayNameNr is required for the x-value of each Datenumber and determines which day the 1st is (0 = Sunday etc.)
			// since getDay() returns a 0 for Sunday, dayNameNr needs to be switched to 7
			var dayNameNr:int = (myDate.getDay() == 0) ? 7 : myDate.getDay();  
			var row:int = 1;
			for(var i:int = 1; i<=daysNr; i++){	
				if(dayNameNr == 1 && i != 1)  row++;  // increases the row-counter
				//////////------------< Container-Sprite for each Datenumber >------------//////////
				var nr_spr = new Sprite();
				nr_spr.buttonMode = true;
				nr_spr.name = i+"."+(mm+1)+"."+yy;
				nr_spr.x = (dayNameNr-1)*32;
				nr_spr.y = row*20+30;
				nr_spr.mouseChildren = false;
				nr_spr.addEventListener(MouseEvent.CLICK, onDateClick);
				nr_spr.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				nr_spr.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				if(xDate.fullYear == yy && xDate.getMonth() == mm  && xDate.getDate() == i)  nr_spr.alpha = 0.3;
				
				//////////------------< Background-Sprite for each Datenumber >------------//////////
				var bgrColor:uint;
				style == "white" ? bgrColor = 0xFFFFFF  : bgrColor = 0x000000;
				var nr_bgr:Sprite = nr_spr.addChild(rect(27,18,bgrColor,0.5));  // rect()-function see below
				nr_bgr.x = 3;
				
				//////////------------< TextField for each Datenumber >------------//////////
				var nr_txt:TextField = new TextField();
				nr_txt.width = 30;
				nr_txt.height = 20;
				nr_txt.text = String(i);
				nr_txt.selectable = false;
								
				// format text & highlight date of today:
				(todayDate.getFullYear() == yy && todayDate.getMonth() == mm  && todayDate.getDate() == i) ? nr_txt.setTextFormat(txtFormat("today")) : nr_txt.setTextFormat(txtFormat("dateGrid"));
				
				calendar.addChild(nr_spr);
				nr_spr.addChild(nr_txt);
				
				dayNameNr == 7 ? dayNameNr = 1 : dayNameNr++;  // if dayNameNr is 7 (Sunday) set it back to 1 (Monday)
			}
		}
		
		
		private function onDateClick(e:MouseEvent):void{
			selectDate = e.target.name;
			m.dispatchEvent(new Event(Event.SELECT));
			//m.parent.removeChild(m);  // removes DatePicker from the MainTimeline
		}
		
///////////////////////////////////////////////////////////////////////////////////////	
////////////////////------------< BUTTON EVENTHANDLER >------------////////////////////	
		
		private function onNextClick(e:MouseEvent):void{
			m.removeChild(calendar);					// remove current DateGrid-Sprite
			if(isNaN(mCount)) mCount = xDate.month;    	// initialize month-Counter but only if not already set
			if(isNaN(yCount)) yCount = xDate.fullYear; 	// initialize year-Counter but only if not already set
			if(mCount == 11){							// if month == 11 (December)
				mCount = 0;								// set month to 0 (January)
				yCount++;								// and increase the year counter by 1
			} else {
				mCount++;								// else increase month counter by 1
			}
			drawDateGrid(mCount, yCount);				// make DateGrid-Sprite for the next month
		}
		
		private function onPrevClick(e:MouseEvent):void{
			m.removeChild(calendar);					// remove current DateGrid-Sprite
			if(isNaN(mCount)) mCount = xDate.month;		// initialize month-Counter but only if not already set
			if(isNaN(yCount)) yCount = xDate.fullYear;	// initialize year-Counter but only if not already set
			if(mCount == 0){							// if month == 0 (January)
				mCount = 11;							// set month to 11 (December)
				yCount--;								// and decrease the year counter by 1
			} else {
				mCount--;								// else decrease month counter by 1
			}
			drawDateGrid(mCount, yCount);				// make DateGrid-Sprite for the previous month
		}
		
		private function onOver(e:MouseEvent):void{
			e.target.alpha = 0.5;
		}
		
		private function onOut(e:MouseEvent):void{
			e.target.alpha = 1;
		}

		
////////////////////////////////////////////////////////////////////////////////	
////////////////////------------< UTILITIES >------------////////////////////	
		
		private function txtFormat(str:String):TextFormat{
			var fmt:TextFormat = new TextFormat("Arial",12,fontColor);
			if(str == "dateGrid") fmt.align = TextFormatAlign.RIGHT;
			if(str == "dayNameRow") {
				fmt.bold = true;
				fmt.align = TextFormatAlign.RIGHT;
			}
			if(str == "today") {
				fmt.align = TextFormatAlign.RIGHT;
				fmt.bold = true;
				style == "white" ? fmt.color = 0x042162 : fmt.color = 0xFFE609;
			}
			return fmt;
		}
		
		private function drawArrow(__x:Number,__y:Number,__rot:Number):Sprite{  // creates Arrows for prev_btn & next_btn
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle(1, 0);
			spr.graphics.beginFill(fontColor);
			spr.graphics.lineTo(0,-7.5);
			spr.graphics.lineTo(7.5,0);
			spr.graphics.lineTo(0,7.5);
			spr.graphics.endFill();
			spr.x = __x;
			spr.y = __y;
			spr.rotation = __rot;
			return spr;
		}
		
		private function drawRadialBackground(tw:Number, th:Number):Sprite{  // creates background with gradient-fill
			var bg:Sprite = new Sprite();
			var fillType:String = GradientType.LINEAR;
			var colors:Array = new Array();
			style == "white" ? colors= [0xEEEEEE, 0xBFBFBF] : colors = [0x4B5767, 0x1F222E];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			var w:Number = tw;
			var h:Number = th;
			matr.createGradientBox(tw, th, 90, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			bg.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			bg.graphics.lineStyle(2, 0xD9D9D9);
			bg.graphics.drawRoundRect(0, 0, tw, th, 5);
			//=============== apply Filter ===============//
			var glowColor:uint;
			style == "white" ? glowColor = 0x888888  : glowColor = 0x000000;
			//glowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout)
			var glowFilter:BitmapFilter = new GlowFilter(glowColor, 1, 50, 25, 1, BitmapFilterQuality.HIGH, true, false);
			//shadowFilter( distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout)
			var shadowFilter:DropShadowFilter = new DropShadowFilter(5,90,0x000000,1,10,10,0.9,BitmapFilterQuality.LOW,false,false);
			var myFilter:Array = new Array(glowFilter, shadowFilter);
			bg.filters = myFilter;
			return bg;
		}
		
		private function rect(w:Number,h:Number,col:uint, alph:Number):Sprite{  // creates a simple rect with a color-fill
			var s:Sprite = new Sprite();
			s.graphics.beginFill(col,alph);
			s.graphics.drawRoundRect(0,0,w,h,10);
			s.graphics.endFill();
			return s;
		}

	}
}