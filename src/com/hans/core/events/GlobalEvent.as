package com.hans.core.events
{
	import flash.events.Event;
	
	/**
	 *GlobalEvent.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-3-25
	 */
	public class GlobalEvent extends Event
	{
		/**
		 *游戏开始启动 
		 */		
		public static const GAMESTAST:String = "game_start";
		/**
		 *游戏启动完成 
		 */
		public static const GAMECOMPLETE:String = "game_start_complete";
		/**
		 *游戏发生严重错
		 */
		public static const BigError:String = "game_needto_restat";
		
		/**
		 *游戏启动状态 
		 */		
		public var status:uint = 0;
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, status:uint = 0)
		{
			super(type, bubbles, cancelable);
			this.status = status;
		}
		override public function clone():Event
		{
			var event:GlobalEvent =  new GlobalEvent(type, bubbles, cancelable);
			event.status = this.status;
			return event;
		}
	}
}