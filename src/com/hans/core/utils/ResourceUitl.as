package com.hans.core.utils
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	/**
	 *ResourceUitl.as：
	 *<p>素材加管理</p>
	 *@author:Hans
	 *@date:2012-4-15
	 */
	public class ResourceUitl
	{
		public function ResourceUitl()
		{
			
		}
		public static function  getDisplayByName(className:String):DisplayObject
		{
			var cls:Class = getDefinitionByName(className) as Class;
			if(cls)
			{
				//如果是素材类
				if(cls.prototype == Bitmap)
				{
					trace("素材是bitmap");
				}else{
					return new cls();
				}
				
			}else{
				Debug.error("ResourceUitl:"+getQualifiedClassName(cls)+" is not a DisplayObject");
			}
		}
		
	}
}