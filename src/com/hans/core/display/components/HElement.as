package com.hans.core.display.components
{
	import com.hans.core.display.HSprite;
	import com.hans.core.utils.Debug;
	
	/**
	 *Element.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-27
	 */
	public class HElement extends HSprite
	{
		private var _index:int = 0;
		
		public function HElement()
		{
			super();
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

	}
}