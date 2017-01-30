package com.hans.core.view.impl
{
	import flash.display.Sprite;
	
	public class SyncViewBase extends Sprite
	{
		protected var url:String;
		
		public function SyncView(){
			
		}
		/**
		 * URl拼装 
		 * @return 
		 * 
		 */		
		protected function getURL():String
		{
			// TODO:完善逻辑
			return "";
		}
		/**
		 *素材加载完成后的操作，显示，初始化等 
		 * 
		 */		
		protected function loaded():void{
			//取消加载状态
		}
	}
}