package com.hans.core.utils
{
	/**
	 *TimeUitl.as：时间工具
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-12
	 */
	public class TimeUitl
	{
		public static function PHP2AS(phptime:uint):uint
		{
			return phptime* 1000;
		}
		public static function FromatTime(timestamp:int):String
		{
			var str:String="";
			str +=Math.floor(timestamp / 3600)? Math.floor(timestamp / 3600)+":" : "";
			str +=timestamp / 60 || str.length>=2 ? Math.floor(timestamp / 60)+":" : "0:" ;
			str += (timestamp % 60)>=10 ? (timestamp % 60).toString() : "0"+(timestamp % 60) ;
			return str;
		}
	}
}