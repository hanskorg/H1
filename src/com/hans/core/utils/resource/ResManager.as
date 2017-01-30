package com.hans.core.utils.resource
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.hans.core.loader.Loader;
	import com.hans.core.loader.LoaderItem;
	import com.hans.core.loader.LoaderType;
	import com.hans.core.utils.Debug;
	import com.hans.core.utils.cache.DisplayCachePool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 *ResManager.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-4-30
	 */
	public class ResManager
	{
		/**
		 *缓存池 
		 */
		private var cachePool:Dictionary;
		
		public function ResManager()
		{
		}
		public function getDisplayObjectByName(className:String,loaderItem:LoaderItem=null):DisplayObject{
			var cls:Class ;
			var sp:Sprite = DisplayCachePool.getInstance().getSprite(className);
			if(sp)
			{
				return sp;
			}
			if(!loaderItem){
				cls = getDefinitionByName(className) as Class;
				return new cls() as DisplayObject;
			}else{
				var onCompleteCallback:Function = function():void
				{
					//加载完成回调
					if(loaderItem.cacahed)
					{
						for each(var clsName:String in loaderItem.cacheClasses)
						{						
							cls = getDefinitionByName(className) as Class;
							DisplayCachePool.getInstance().cacheDisplay(clsName,new cls());
						}
					}
					if(loaderItem.onComplete.length){
						
						sp = DisplayCachePool.getInstance().getSprite(className);
						if (!sp) {
							var _clz : Class = getDefinitionByName(className) as Class;
							sp = new _clz();
						}
						loaderItem.onComplete.apply(null,sp);
					}else{
						Debug.warning("不存在加载完成回调");
					}
				}
				Loader.synLoad(loaderItem.url,loaderItem.url,loaderItem.type,loaderItem.onComplete);
				return null;
			}
				
		}
		
		public function getBitmapByPath(path:String,container:DisplayObjectContainer):void
		{
			var bitmap:* = LoaderMax.getContent(path);
			var onComplete:Function = function():void
			{
				bitmap = LoaderMax.getContent(path);
				container.addChild(bitmap);
				Debug.log("图片加载完成"+path);
			}
			if(bitmap){
				container.addChild(bitmap);
			}
			else
			{
				var loader:LoaderItem = new LoaderItem();
				loader.name = path;
				loader.url = path;
				loader.type = LoaderType.IMAGE;
				loader.onComplete = onComplete;
				Loader.aysnLoad(loader);
			}
		}
			
	}
}