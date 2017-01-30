package com.hans.core.view.impl
{
	import com.hans.core.view.IMoveAble;
	
	import flash.display.MovieClip;
	
	/**
	 *MoveAble.as：可移动元件
	 *<p></p>
	 *@author:Hans
	 *@date:2012-3-25
	 */
	public class MoveAble extends MovieClip implements IMoveAble
	{
		public function MoveAble()
		{
		}
		public function setX(_arg1:Number):void
		{
			this.x = _arg1;
		}
		
		public function getX():Number
		{
			return (this.x);
		}
		
		public function setY(_arg1:Number):void
		{
			this.y = _arg1;
		}
		
		public function getY():Number
		{
			return (this.y);
		}
		
		public function getWidth():Number
		{
			return (this.width);
		}
		
		public function getHeight():Number
		{
			return (this.height);
		}
	}
}