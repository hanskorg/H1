package com.hans.core.utils
{
	import flash.display.DisplayObjectContainer;

	/**
	 *SrcollingList.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-25
	 */
	public class SrcollingList
	{
		private var _dataList:Array;
		public var weightList:Vector.<ScrollingElement>;
		public var currentIndex:uint=0;
		public var pageSize:uint=5;
		
		private var _weightCls:Class;
		
		/**
		 * 构造函数 
		 * @param rowNum 行数
		 * @param cols 列数
		 * @param mode 
		 * @param mation
		 * 
		 */		
		public function SrcollingList(container:DisplayObjectContainer,weigh:Class,rowNum:uint=1,cols:uint=5,hSpace:int=0,vSpace:int=0,mode:Mode=Mode.VERTICAL,mation:Mode = Mode.ANIMATION)
		{
			weightList = new Vector.<ScrollingElement>();
			_dataList = [];
		}
		public function update(data:Array):void
		{
			
		}
		public function scrollTo(index:int):void
		{
			
		}
		public function pageNext():void
		{
			
		}
		public function pagePre():void
		{
			
		}
		public function pageFirst():void
		{
			
		}
		public function pageEnd():void
		{
			
		}
		private function render(startIndex:uint,endIndex:uint):void
		{
			
		}
		private function unRender():void
		{
			
		}
		private function unRenderAll():void
		{
			
		}
	}
}
class Mode {
	public static const HORIZONTAL : Mode = new Mode();
	public static const VERTICAL : Mode = new Mode();
	public static const ANIMATION : Mode = new Mode();
	public static const NOANIMATION : Mode = new Mode();
}