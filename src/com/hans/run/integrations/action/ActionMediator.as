package com.hans.run.integrations.action
{
	import com.hans.run.integrations.action.view.BattleScene;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 *ActionMediator.as：战斗管理器
	 *<p></p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class ActionMediator extends Mediator
	{
		[Inject]
		public var model:ActionModel;
		/**战斗场景*/
		public var view:BattleScene;
		
		public function ActionMediator()
		{
			super();
			/**注册事件*/
		}
		/**
		 * 启动场景 
		 */		
		public function startup():void
		{
			
		}
		override public function onRemove():void
		{
			
		}
		
	}
}