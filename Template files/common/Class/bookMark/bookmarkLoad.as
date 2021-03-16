/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package bookMark{
	import common.commonfunctions;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.*;

	public class bookmarkLoad extends MovieClip {
		public var swfIndex:Number;
		public var mainSWF;
		public var bookmark;
		var stageAll;

		public function bookmarkLoad(stageall:Object,swfIndex:Number,mSWF:Object,bookmark:Array) {
			this.swfIndex=swfIndex;
			mainSWF=mSWF;
			stageAll=stageall;
			this.bookmark=bookmark;
			clipClicked();
		}
		private function clipClicked() {
			stageAll.parentClip.removeChild(stageAll.mainSWF);
			stageAll.PlayScene=bookmark[swfIndex][1];
			stageAll.mainSWF=stageAll.loadall.loadnewSWF(bookmark[swfIndex][0],false);
		}

	}

	///end class....
}