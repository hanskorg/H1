package com.hans.run.controllers
{
	import com.hans.core.utils.SWFProfiler;
	import com.hans.run.Config;
	import com.hans.run.MainContext;
	import com.hans.run.common.ViewRoot;
	import com.hans.run.events.CoreEvent;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 *InitCommand.as：
	 *<p>初始化控制器</p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class InitCommand extends Command
	{
		[Inject]
		public var viewRoot:ViewRoot;
		
		public function InitCommand()
		{
			super();
		}
		override public function execute():void
		{
			done();
		}
		/**
		 * 加载文件 
		 */		
		private function loadConfig():void
		{
			
		}
		private function parseConfig(config:XML):void
		{
			
		}
		/**
		 * 初始化工作完成
		 **/
		private function done():void
		{
			//添加DEBUG
			if(Config.DEBUG)
			{
				SWFProfiler.init(contextView.stage,contextView);
			}
			var event:CoreEvent = new CoreEvent(CoreEvent.INITED);
			eventDispatcher.dispatchEvent(event);
		}
	}
}