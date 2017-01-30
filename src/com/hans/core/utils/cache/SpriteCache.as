package com.hans.core.utils.cache
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 让单个缓存数据在Sprite中显示
	 * 单个不动的矢量图可以通过开启cacheAsBitmap = true完成内置缓存，不用使用此缓存类
	 * @author 翼翔天外
	 * 
	 */
	public class SpriteCache extends Sprite
	{
		private var _bmp:Bitmap;
		/**
		 * 
		 * @param bitmapDataCache	位图缓存数据
		 * @param disableMouse		是否禁用鼠标
		 * 
		 */
		public function SpriteCache(bitmapDataCache:BitmapDataCache,disableMouse:Boolean = true)
		{
			super();
			_bmp = new BitmapCache(bitmapDataCache);
			addChild(_bmp);
			this.mouseChildren = false;
			if(disableMouse)
			{
				this.mouseEnabled = false;
			}
		}

		public function get bmp():Bitmap
		{
			return _bmp;
		}

	}
}