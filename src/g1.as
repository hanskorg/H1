package
{
	import com.hans.run.MainContext;
	
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	
	/**
	 *g1.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2013-5-16
	 */
	[SWF(width="800",height="600")]
	public class g1 extends Sprite
	{
		public function g1()
		{
			setSecurity();
			startup();
		}
		/**
		 * 设置安全策略 
		 * 
		 */		
		private function setSecurity():void
		{
			Security.allowDomain("*");
			Security.loadPolicyFile("http://www.adobe.com/crossdomain.xml");
		}
		/**
		 * 传入加载壳的参数 
		 * @param params
		 * 
		 */		
		public function setParams(params:Object):void
		{
			
		}
		
		/**
		 * 传出加载器加载进度 
		 * @return 
		 * 
		 */		
		public function getProcess():int
		{
			return 0;
		}
		
		private function startup():void
		{
			new MainContext(this);
		}
	}
}