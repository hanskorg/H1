package com.hans.core.model
{
	public interface IModel
	{
		function add(data:IData):void;
		function getData(index:Object):IData;
		function deleteOne(index:Object):Boolean;
	}
}