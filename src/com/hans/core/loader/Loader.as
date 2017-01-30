package com.hans.core.loader
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 *Loader.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-4-15
	 */
	public class Loader
	{
		private static var syncLoader:LoaderMax;
		public function Loader()
		{
			
		}
		/**
		 * 同步加载对象 
		 * @param uri
		 * @param type
		 * @param progressHandler
		 * @param completeHandler
		 * @param errorHandler
		 * 
		 */
		public static function synLoad(name:String,uri:String,type:uint,onComplete:Function,onProgress:Function=null,error:Function=null,onItemComplete:Function=null):void
		{
			
			var progressHandler:Function = function(evt:LoaderEvent):void
			{
				if(onProgress!=null)
					onProgress(evt.target.progress);
			}
			var completeHandler:Function = function(evt:LoaderEvent):void
			{				
				onComplete();
			}
			var errorHandler:Function = function(evt:LoaderEvent):void
			{
				if(error!=null)
					errorHandler();
			}
			if(!syncLoader)
			{
				syncLoader = new LoaderMax({name:"syncLoader", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			}
			var loadername:String = name && name!="" ? name : uri;
			switch(type)
			{
				case LoaderType.SWF:
					var context:LoaderContext = new LoaderContext(false);
					context.applicationDomain = ApplicationDomain.currentDomain;
					syncLoader.prepend(new SWFLoader(uri,{context:context,name:loadername}));
					break;
				case LoaderType.XML:
					syncLoader.prepend(new XMLLoader(uri,{name:loadername,onComplete:onItemComplete,datatype:"map"}));
					break;
				case LoaderType.IMAGE:
					syncLoader.append(new ImageLoader(uri,{name:loadername}));
					break;
				case LoaderType.BINARY:
					syncLoader.append(new DataLoader(uri,{name:loadername}));
					break;
			}
			syncLoader.load();
		}
		public static function aysnLoad(loader:LoaderItem):void
		{
			switch(loader.type)
			{
				case LoaderType.SWF:
					var contexta:LoaderContext = LoaderContext(true);
					contexta.applicationDomain = ApplicationDomain.currentDomain;
					contexta.securityDomain = SecurityDomain.currentDomain;
					new SWFLoader(loader.url,{name:loader.url,context:contexta,onComplete:loader.onComplete}).load();
					break;
				case LoaderType.XML:
					new XMLLoader(loader.url,{name:loader.url,onComplete:loader.onComplete}).load();
					break;
				case LoaderType.IMAGE:
					new ImageLoader(loader.url,{name:loader.url,onComplete:loader.onComplete}).load();
					break;
				case LoaderType.BINARY:
					new DataLoader(loader.url,{name:loader.url,onComplete:loader.onComplete}).load();
					break;
			}
		}
		public static function getLoader():LoaderMax
		{
			return syncLoader;
		}
		
		
	}
}