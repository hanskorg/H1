package com.hans.core
{
	import com.hans.core.display.HSprite;
	import com.hans.core.utils.resource.ResManager;
	import com.hans.core.remoting.Request;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import org.robotlegs.base.ViewInterfaceMediatorMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;

	public class ClientBase extends Context
	{
		/**
		 * 
		 * 
		 */
		public function ClientBase(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			/**初始化缓存容器*/
			Request.DescribeTypeCache = new Dictionary();
			HSprite.resManager = new ResManager();
			/**初始化资源管理器*/
			super(contextView, autoStartup);
		}
		override public function startup():void
		{
			this.injector.mapSingletonOf(ResManager,ResManager);
		}
		override protected function get mediatorMap():IMediatorMap
		{
			return new ViewInterfaceMediatorMap(contextView, injector, reflector);
		}
	}
}