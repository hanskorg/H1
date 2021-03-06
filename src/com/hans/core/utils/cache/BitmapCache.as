package com.hans.core.utils.cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 位图缓存容器
	 * @author 翼翔天外
	 * 
	 */
	public class BitmapCache extends Bitmap
	{
		/**
		 * 位图缓存数据 
		 * @param bitmapDataCache
		 * 
		 */
		public function BitmapCache(bitmapDataCache:BitmapDataCache)
		{
			super(bitmapDataCache, "auto", true);
			this.x = bitmapDataCache.offsetX;
			this.y = bitmapDataCache.offsetY;
		}
		
		/**
		 * 设置缓存数据 
		 * @param value
		 * 
		 */
		public function set bitmapDataCache(value:BitmapDataCache):void
		{
			this.bitmapData = value;
			this.x = value.offsetX;
			this.y = value.offsetY;
		}
		
		/**
		 * 获得缓存数据 
		 * @return 
		 * 
		 */
		public function get bitmapDataCache():BitmapDataCache
		{
			return this.bitmapData as BitmapDataCache;
		}
	}
}