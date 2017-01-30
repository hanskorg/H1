package com.hans.core.utils
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.flash_proxy;

	/**
	 *ReflectUtil.as：
	 *<p>反射工具</p>
	 *@author:Hans
	 *@date:2012-4-15
	 */
	public class ReflectUtil
	{
		
		/**
		 *描述XML 
		 */
		private var descriptXML:XML;
		/**
		 *cache容器 
		 */		
		private var reflectCache:Dictionary;
		/**
		 * ReflectUtil实例 
		 */		
		private static var _instance:ReflectUtil;
		
		/**
		 * 构造反射实例 
		 * 
		 */		
		public function ReflectUtil()
		{
			reflectCache = new Dictionary();
		}
		/**
		 * 映射素材 
		 * 
		 */		
		public static function map2Res(reflectInstance:DisplayObject,resouce:DisplayObjectContainer):void
		{
			if(!_instance)
			{
				_instance = new ReflectUtil();
			}
			_instance.reflect(reflectInstance,resouce);
		}
		/**
		 * 将实际素材映射到目标Sprite上 
		 * @param desc
		 * @param orgiRes
		 * 
		 */		
		private function reflect(target:Object,orgiRes:DisplayObjectContainer):void
		{
			this.descriptXML = describeTypeCache(target);
			var list : XMLList = descriptXML.*;
			var item : XML;
			//缓存容器
			var propMap:Dictionary = new Dictionary();
			for each (item in list) {
				var itemName : String = item.name().toString();
				switch(itemName) {
					case "variable":
						propMap[item.@name.toString()] = item.@type.toString();
						break;
					case "accessor":
//						var access : String = item.@access;
//						if((access == "readwrite") || (access == "writeonly")) {
//							propMap[item.@name.toString()] = item.@type.toString();
//						}
						break;
				}
			}
			for(var prop:String in propMap)
			{
				var obj:Object = this.map(prop,orgiRes);
				target[prop] = obj!=null ? obj : target[prop];
			}
		}
		/**
		 * 映射素材元件
		 * @param property
		 * @param resouce
		 * 
		 */		
		private function map(property:String,resouce:DisplayObjectContainer):DisplayObject
		{
			var res:DisplayObject = resouce.getChildByName(property);
			return res;
		}
		/**
		 * 获取xml描述 
		 * @param desc
		 * @return 
		 * 
		 */		
		private function describeTypeCache(desc:Object):XML
		{
			var name:String = getQualifiedClassName(desc);

			if(!this.reflectCache[name])
			{
				this.reflectCache[name] = describeType(desc);
			}
			return this.reflectCache[name];
		}

	}
}