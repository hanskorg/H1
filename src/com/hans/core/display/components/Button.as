package com.hans.core.display.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 *Button.as：斯泰按钮
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-6
	 */
	public class Button
	{
		private var _instance:MovieClip;
		private var _active:Boolean = true;
		private var _clickHandler:Function;
		private var _overHandler:Function;
		private var _canChecked:Boolean = false;
				
		public function Button(mc:MovieClip,clickhandler:Function=null,mouseOverHander:Function=null,canChecked:Boolean = false)
		{
			this._instance = mc;
			this._clickHandler = clickhandler;
			this._overHandler = mouseOverHander;
			this._canChecked = canChecked;
			_instance.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
			if(_instance.totalFrames>=2){
				_instance.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
				_instance.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
			}
			_instance.addEventListener(MouseEvent.CLICK,this.onClick);
			this._instance.gotoAndStop(1);
		}


		private function onOver(evt:MouseEvent):void
		{
			if(this._active)
				this._instance.gotoAndStop(2);
		}
		private function onOut(evt:MouseEvent):void
		{
			if(this._active)
				this._instance.gotoAndStop(1);
		}
		private function onDown(evt:MouseEvent):void
		{
			this._instance.gotoAndStop(3);
		}
		private function onClick(evt:MouseEvent):void
		{
			if(this._canChecked){
				this._active = false;
				this._instance.gotoAndStop(this._instance.totalFrames);
			}else{
				this._instance.gotoAndStop(1);
			}
			if(this._clickHandler!=null)
			{
				this._clickHandler.apply(null,[evt]);
			}
		}
		/**
		 *销毁方法 
		 * 
		 */		
		public function dispose():void
		{
			_instance.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
			_instance.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
			_instance.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
			_instance.removeEventListener(MouseEvent.CLICK,this.onClick);

		}
		public function get active():Boolean
		{
			return this._active;
		}
		/**按钮是否活动状态*/
		public function set active(value:Boolean):void
		{
			_active = value;
			this._instance.gotoAndStop(1);
		}
		
	}
}