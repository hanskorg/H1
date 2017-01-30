package com.hans.core.utils.cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 缓存对象的鼠标辅助类 Bata0.9  (考虑到效率，不应该在MOUSE_MOVE不停的抛出事件)
	 * 用于缓存对象禁用鼠标后的鼠标检测
	 * 监听主容器的鼠标事件
	 * 然后遍历缓存对象，通过本类传入鼠标事件
	        private function onStageClick(e:MouseEvent):void
			{
				var num:int = _mcList.length;
				for(var i:int = 0 ; i < num ; i++)
				{
					CacheMouseChecker.sendEventToCacheObj(_mcList[i],e);
				}
			}
	 * 缓存对象拥有事件：MouseEvent.CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT.
	 * @author 翼翔天外
	 * 
	 */
	public class CacheMouseChecker
	{
		public function CacheMouseChecker()
		{
		}
		
		public static function sendEventToCacheObj(cacheObj:Object,event:MouseEvent):void
		{
			//获取位图
			var bmp:Bitmap = cacheObj.bmp;
			var bmd:BitmapData = bmp.bitmapData;
			var mousePoint:Point = new Point(event.stageX,event.stageY);
			var localPoint:Point = bmp.globalToLocal(mousePoint);
			//检测透明度
			var color:uint = bmd.getPixel32(localPoint.x,localPoint.y);
			//取透明度
			var alpha:uint = (color >> 24) & 0xFF;
			//透明度不为0 检测成功
			if(alpha != 0)
			{
				switch(event.type)
				{
					case MouseEvent.CLICK:
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
						break;
					case MouseEvent.MOUSE_DOWN:
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,false));
						break;
					case MouseEvent.MOUSE_UP:
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,false));
						break;
					case MouseEvent.MOUSE_MOVE:
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false));
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE,false));
						break;
				}
			}
			else
			{
				switch(event.type)
				{
					case MouseEvent.MOUSE_MOVE:
						IEventDispatcher(cacheObj).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,false));
						break;
				}
			}
		}
	}
}