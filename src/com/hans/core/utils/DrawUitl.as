package com.hans.core.utils
{
	import flash.display.Sprite;

	/**
	 *DrawUitl.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-27
	 */
	public final class DrawUitl
	{
		public static function drawRect(width:Number,height:Number,color:int=0x000000,alpha:Number=1):Sprite
		{
			var sp:Sprite = new Sprite();
			var pen:Pen = Pen.GET(sp.graphics);
			pen.beginFill(color,alpha);
			pen.drawRect(0,0,width,height);
			pen.endFill();
			return sp;
			
		}
	}
}