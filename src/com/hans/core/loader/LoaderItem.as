package com.hans.core.loader
{
	import flash.utils.Dictionary;

	/**
	 *LoaderItem.as：
	 *<p>素材加载项</p>
	 *@author:Hans
	 *@date:2012-4-30
	 */
	public class LoaderItem
	{
		public var name:String;
		public var type:uint;
		public var url:String;
		public var onComplete:Function;
		public var onFail:Function;
		/**
		 *movieClip类型不支持缓存 
		 */		
		public var cacahed:Boolean = false;
		public var cacheClasses:Dictionary ;
	}
}