package com.hans.core.remoting
{
	import com.hans.core.remoting.core.IRequest;
	import com.hans.core.utils.Debug;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 *Request.as：<code></code>
	 *<p>消息体基类</p>
	 *@author:Hans
	 *@date:2012-4-22
	 */
	dynamic public class Request  extends Actor implements IRequest
	{
		
		/**通信失败，是不是终端游戏*/		
		public var safe:Boolean = false;
		
		/**同步操作，处理失败或者相应未结束不在发送请求*/		
		protected var sync:Boolean = false;
		/**协议名称*/		
		protected var callName:String;
		/**协议类型，默认异步消息 */		
		protected var _type:String = RequestType.AYNC;
		/**参数数组*/		
		protected var _args:Array;
		
		/**请求失败是否允许请求重试*/		
		public var retry:Boolean = true;
		public var retryTime:uint = 1;
		
		public function Request()
		{
		}
		
		public function onResponse(respose:Object):void
		{
			
		}
		
		public function onFault(respose:String):void
		{
			
		}
		
		public function get remoteServiceName():String
		{
			throw new IllegalOperationError(getQualifiedClassName(this)+"：RPC名称为定义");
			return null;
		}
		
		public function get requestVars():Array
		{
			if(!_args){
				_args = [];
				
				if(!DescribeTypeCache[this.callName])
				{
					DescribeTypeCache[this.callName] = describeType(this);
				}
				var xmllist:XMLList = DescribeTypeCache[this.callName].variable;
				var obj:Object = {};
				for each(var xml:XML in xmllist)
				{
					if(XMLList(xml.metadata.(@name=="Arg")).length())
					{
						obj[(xml.@name)]= this[xml.@name];
					}
				}
				_args.push(obj);
			}
			return _args;
		}
		
		public function set requestVars(args:Array):void
		{
			_args = args;
		}
		
		public function get remoteCallName():String
		{
			if(!callName)
				throw new IllegalOperationError("缺少协议名称");
			return this.callName;
		}
		
		public function set type(value:String):void
		{
			this._type = value;
			
		}
		
		public function get type():String
		{
			return this._type;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function willTrigger(type:String):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		public static var DescribeTypeCache:Dictionary = new Dictionary();;
		
	}
}