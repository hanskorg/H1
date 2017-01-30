package com.hans.run.events
{
	import flash.events.Event;
	
	/**
	 *CoreEvent.as：
	 *<p>全局事件</p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class CoreEvent extends Event
	{
		/**初始化完成*/
		public static const INITED:String = "coreevent.initd";
		/**资源加载完成*/
		public static const LOADED:String = "coreevent.loaded";
		/**资源加载进度*/
		public static const PROCESS:String = "coreevent.process";
		
		public function CoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var event:CoreEvent = new CoreEvent(type,bubbles,cancelable);
			return event;
		}
	}
}