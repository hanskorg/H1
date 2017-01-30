package com.hans.core.utils
{
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	
	public class ScrollingElement extends MovieClip
	{
		private var mActive:Boolean;
		private var mIndex:int;
		public function ScrollingElement()
		{
			mActive = false;
		}
		public function set index(__index:uint):void{
			this.mIndex = __index;
		}
		public function get index():uint{
			return this.mIndex;
		}
		
		public function set active(__active:Boolean):void{
			this.mActive = __active;
			this.visible = __active;
		}
		public function init(_data:Object):void{
			throw new IllegalOperationError("you shold override this function");
		}
	}
}