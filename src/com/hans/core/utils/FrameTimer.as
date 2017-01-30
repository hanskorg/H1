package com.hans.core.utils
{
	import com.hans.run.MainContext;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 *FrameTimer.as：框架计时器
	 *<p>功能描述：
	 * 1：倒计时，触发回调
	 * </p>
	 *@author:Hans
	 *@date:2012-5-12
	 */
	public class FrameTimer
	{
		private var _maintimer:Timer;
		private var _timers:Dictionary;
		private var itmerId:uint = 0;
		private var lastTime:uint;
		
		public function FrameTimer()
		{
			MainContext.instance.addEventListener(Event.ENTER_FRAME,this.tick);
			_timers = new Dictionary();
			_timers["length"] = 0;
		}

		private function tick(evt:Event):void
		{
			if(getTimer()-lastTime<1000) return;
			for each(var timer:* in this._timers)
			{
				if(timer is int) break;
				if(lastTime - timer.current<timer.delay) break;
				timer.time++;
				if(timer["time"] == 0 && timer["type"]==TimerType.WHITCOMPLETE)
				{
					if(timer["onComplete"])
						timer["onComplete"].apply(null);
					timer["onTick"].apply(null,[timer.time]);
					delete _timers[timer.id];
					this._timers["length"]--;
				}else{
					timer["onTick"].apply(null,[timer.time]);
				}
			}
			this.lastTime = getTimer();
		}
		private function get timerId():uint
		{
			return itmerId++;
		}
		public function start():void
		{
			this.lastTime = getTimer();

		}
		/**
		 * 加入计时器 
		 * @param time 负数为倒计时
		 * @param onTick
		 * @param onComplete
		 * 
		 */		
		public function join(time:int,delay:int=1,onTick:Function=null,onComplete:Function=null):int
		{
			start();
			var type:uint = time==0 ? TimerType.WHITOUTCOMPLETE : TimerType.WHITCOMPLETE;
			var lasttime:int = getTimer();
			var timer:MyTimer = new MyTimer();
			timer.time = time;
			timer.delay = delay;
			timer.onTick = onTick;
			timer.onComplete = onComplete;
			timer.id = this.timerId;
			timer.current = getTimer();
			timer.type = type;
			this._timers[timer["id"]] = timer;
			_timers["length"]++;
			return timer["id"];

		}
		public function disposetimer(timerid:int):void
		{
			delete this._timers[timerid];
		}
	}
}
internal class TimerType
{
	public static const WHITOUTCOMPLETE:uint=0;
	public static const WHITCOMPLETE:uint=0;
}
internal class MyTimer
{
	public var id:int;
	public var lasttime:int;
	public var type:uint;
	public var current:int;
	public var delay:int=1;
	public var time:int;
	public var onTick:Function;
	public var onComplete:Function;
}
