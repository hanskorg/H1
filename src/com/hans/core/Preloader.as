package com.hans.core {
	import com.hans.core.utils.Debug;
	import com.hans.core.utils.SWFProfiler;
	import com.hans.core.utils.SplitFileLoader;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class Preloader  extends Sprite
	{
		public function Preloader()
		{
			loadXmls();
			Security.allowDomain("*");
			Security.loadPolicyFile("http://dev.hansk.org:7890/crossdomain.xml"); 
			
		}
		
		public function loadXmls():void{
			var loader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(Configure.ConfigURL);
			loader.addEventListener(Event.COMPLETE,function(evt:Event):void{
				loadAsset(XMLList(XML(evt.target.data).file));
			});
			loader.load(urlRequest);
		}
		private function loadAsset(_xmlist:XMLList):void{
			var __urList:Array = new Array();
			var splitFileLoader:SplitFileLoader;
			for each(var _xml:XML in _xmlist){
				__urList.push( _xml.attribute("name").toString() );
			}
			splitFileLoader = new SplitFileLoader(__urList);
			splitFileLoader.addEventListener(ProgressEvent.PROGRESS,this.onLoadAssetProcess);
			splitFileLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
			splitFileLoader.load(0,"http://dev.hansk.org/","");
		}
		
		private function onLoadAssetProcess(evt:ProgressEvent):void{
			Debug.log("byteLoaded ："+evt.bytesLoaded);
			this.initRPC();

		}
		private function onLoadError(evt:IOErrorEvent):void{
			
		}
		private function initRPC():void{
			if(Configure.DEBUG){
				SWFProfiler.init(this.stage,this);
				SWFProfiler.start();
			}
			return ;
		}
	}
}