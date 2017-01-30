package com.hans.core.display.components
{
	/**
	 *HListMode.as：
	 *<p>List组件类型</p>
	 *@author:Hans
	 *@date:2012-5-27
	 */
	public class HListMode extends Object
	{
		private var _value:String = "";
		/**
		 *纵向移动 
		 */		
		public static const HORIZONTAL : HListMode = new HListMode("horizontal");
		/**
		 *横向移动 
		 */
		public static const VERTICAL : HListMode = new HListMode("vertical");
		/**
		 *带缓动动画 
		 */		
		public static const ANIMATION : HListMode = new HListMode("animation");
		/**
		 *不带缓动动画 
		 */		
		public static const NOANIMATION : HListMode = new HListMode("noanmition");
		
		public function HListMode(value:String)
		{
			this._value = value;
		}
		public function valueOf():Object
		{
			return this._value;
		}
	}
}