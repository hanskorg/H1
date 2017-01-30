package com.hans.core.utils.cache
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 让单个缓存数据在Sprite中显示(360度旋转缓存) 
	 * @author 翼翔天外
	 * 
	 */
	public class SpriteCache360 extends Sprite
	{
		private var _bmp:BitmapCache;
		private var _bitmapDataCache360:BitmapDataCache360;
		private var _rotation:int = 0;
		/**
		 * 
		 * @param bitmapDataCache360	位图缓存数据
		 * @param disableMouse			是否禁用鼠标
		 * 
		 */
		public function SpriteCache360(bitmapDataCache360:BitmapDataCache360,disableMouse:Boolean = true)
		{
			super();
			_bitmapDataCache360 = bitmapDataCache360;
			_bmp = new BitmapCache(_bitmapDataCache360.getBitmapDataCache(0));
			addChild(_bmp);
			this.mouseChildren = false;
			if(disableMouse)
			{
				this.mouseEnabled = false;
			}
		}
		
		//-------------------- 重写的方法和属性 --------------------
		
		public function get bmp():BitmapCache
		{
			return _bmp;
		}

		override public function set rotation(value:Number):void
		{
			_rotation = Math.round(value);
			_bmp.bitmapDataCache = _bitmapDataCache360.getBitmapDataCache(_rotation);
		}
		
		override public function get rotation():Number
		{
			return _rotation;
		}
	}
}