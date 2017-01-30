package com.hans.run
{
	import com.hans.core.ClientBase;
	import com.hans.run.common.ViewRoot;
	import com.hans.run.controllers.InitCommand;
	
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	
	import org.robotlegs.base.ContextEvent;
	
	/**
	 *MainContext.as：
	 *<p>全局上下文</p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class MainContext extends ClientBase
	{
		private static var _instance:MainContext;
		
		public function MainContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			if(MainContext._instance!=null)
			{
				new IllegalOperationError("单例，请勿重复构造！");
			}
			super(contextView, autoStartup);
			MainContext._instance = this;
			
		}
		
		override public function startup():void
		{
			//初始化显示列表
			var viewRoot:ViewRoot = new ViewRoot();
			this.contextView.addChild(viewRoot);
			this.injector.mapValue(ViewRoot,viewRoot);
			//注册启动事件
			this.commandMap.mapEvent(ContextEvent.STARTUP,InitCommand,ContextEvent);
			
			this.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		public static function get instance():MainContext
		{
			if(!_instance)
			{
				_instance = new MainContext();
			}
			return _instance;
		}
	}
}