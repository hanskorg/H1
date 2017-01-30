package com.hans.core.model
{
	import com.hans.core.utils.Debug;
	
	import org.robotlegs.mvcs.Actor;

	/**
	 * 
	 * @author Hans
	 * 
	 */
	public class Model extends Actor implements IModel
	{
		/**数据模型*/
		public var dataType:Class = null;
		
		private var list:* = null;
		public function Model()
		{
			super();
		}
		/**
		 * 数据解析，保存为模型数据 
		 * @param obj
		 * 
		 */		
		public function parse(obj:Object):void
		{
			if(!dataType)
			for each(var _origdata:Object in obj)
			{
				var desData:IData = new dataType();
				try{
					var result:Boolean = desData.parse(_origdata);
				}catch(e:Error){
					Debug.error("数据解析失败");
				}
				
			}
		}
		
		public function add(data:IData):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function deleteOne(index:Object):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function getData(index:Object):IData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		
		public function dispose():void
		{
			
		}
		
	}
}