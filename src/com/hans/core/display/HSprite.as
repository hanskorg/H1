package com.hans.core.display
{
	import com.hans.core.utils.ReflectUtil;
	import com.hans.core.utils.resource.ResManager;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import avmplus.getQualifiedClassName;
	
	/**
	 *HSprite.as：
	 *<p>显示元件基类</p>
	 *@author:Hans
	 *@date:2012-4-13
	 */
	public class HSprite extends Sprite
	{
		/**原始素材类名*/		
		protected var mcName:String;
		/**时候开启缓存 */		
		public var cached:Boolean = false;
		
		private var _float:Array;

		public static var resManager:ResManager;
		
		public function HSprite()
		{
			init();
		}
		public function init():void{
			if(!mcName) return;
			var mc:Sprite = resManager.getDisplayObjectByName(this.mcName) as Sprite;
			if(mcName)
				ReflectUtil.map2Res(this,mc);
			else
				throw new IllegalOperationError(getQualifiedClassName(this)+"必须重写这个函数");
			this.addChild(mc);
		}
		public function set float(style:*):void
		{
			
		}
		public function dispose():void
		{
			
		}

	}
}