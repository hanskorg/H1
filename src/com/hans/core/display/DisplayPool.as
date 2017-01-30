package com.hans.core.display
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 *DisplayPool.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-4-20
	 */
	public class DisplayPool
	{
		/**
		 *缓存池 
		 */		
		private static var _pool:Dictionary;
		
		public function DisplayPool()
		{
			_pool = new Dictionary();	
		}
		public static function getMc(mcName:String):Sprite
		{
			
			if(_pool[mcName])
			{
				return _pool[mcName];		
			}
			var cls:Class = getDefinitionByName(mcName) as Class;
			return cls() as Sprite;
			
		}
	}
}