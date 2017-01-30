package com.hans.run.common
{
	import flash.display.Sprite;
	
	/**
	 *ViewRoot.as：显示对象根路径
	 *<p>显示跟路径</p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class ViewRoot extends Sprite
	{
		public var mapLayer:Sprite;
		public function ViewRoot()
		{
			mapLayer = new Sprite();
			this.addChild(mapLayer);
		}
	}
}