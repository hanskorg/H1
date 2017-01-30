package com.hans.run.integrations.action.view
{
	import com.hans.core.ViewBase;
	
	/**
	 *BattleScene.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class BattleScene extends ViewBase
	{
		/**战斗系统*/
		public var sWidth:int;
		public var sHeight:int;
		
		public function BattleScene()
		{
			super();
		}
		
		public function setPostion(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		override public function dispose():void
		{
			
		}
	}
}