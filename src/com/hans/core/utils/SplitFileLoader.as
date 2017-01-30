package  com.hans.core.utils
{
    import com.hans.core.utils.Debug;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

	/**
	 *	分部加载对象 
	 * @author Hans
	 * 
	 */	
    public class SplitFileLoader extends Object implements IEventDispatcher
    {
        private var dispatcher:EventDispatcher;
        private var mAssetUrlList:Array;
        private var swfStreamArray:Array;
        private var downloadCompletes:int = 0;
        private var totalParts:int = 0;
        public var maxParts:int = 0;
        private var sfLoader:Loader;
        public var swfData:ByteArray;

        public function SplitFileLoader(_urlList:Array)
        {
            this.swfStreamArray = new Array();
            this.sfLoader = new Loader();
            this.swfData = new ByteArray();
            this.mAssetUrlList = _urlList;
            this.dispatcher = new EventDispatcher(this);
			this.maxParts = this.mAssetUrlList.length;
            return;
        }

        public function load( numInPart:int,_prefix:String="",_suffix:String="") : Boolean
        {
            var urlStream:URLStream = null;
            var currentUrl:String = null;
            var loadInfo:Object = null;
            if (numInPart >= this.maxParts)
            {
                trace("SplitFileLoader: 素材文件不存在 " + this.maxParts);
                return false;
            }
            this.totalParts = this.mAssetUrlList.length;
            var numPart:int = 0;
            while (numPart < this.totalParts)
            {
                
				urlStream = new URLStream();
				currentUrl = _prefix+this.mAssetUrlList[numPart]+_suffix;
				urlStream.load(new URLRequest(currentUrl));
				Debug.log("File to be loaded: "+currentUrl);
				urlStream.addEventListener(Event.COMPLETE, this.streamDownloadComplete);
				urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.streamError);
				urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.status);
				urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.error)
				loadInfo = {bytesTotal:0, bytesLoaded:0, stream:urlStream};
				urlStream.addEventListener(ProgressEvent.PROGRESS, this.streamProgress(loadInfo));
                this.swfStreamArray.push(loadInfo);
				numPart++;
            }
            return true;
        }

        private function streamProgress(_obj:Object) : Function
        {
            var obj:* = _obj;
            return function (event:ProgressEvent) : void
            {
                obj.bytesTotal = event.bytesTotal;
                obj.bytesLoaded = event.bytesLoaded;
                fireProgressEvent();
                return;
            }
            ;
        }

        private function fireProgressEvent() : void
        {
            var stream:Object = null;
            var _total:int = 0;
            var _loaded:int = 0;
            for each (stream in this.swfStreamArray)
            {
                
                if (stream.bytesTotal <= 0)
                {
                    return;
                }
				_total = _total + stream.bytesTotal;
				_loaded = _loaded + stream.bytesLoaded;
            }
            this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _loaded, _total));
            return;
        }

        public function streamDownloadComplete(event:Event) : void
        {
            var i:int;
            var splitLoaderCtx:LoaderContext;
            var currentSwfStream:URLStream;
            var __completeNum:* = this.downloadCompletes + 1;
            this.downloadCompletes = __completeNum;
            if (this.downloadCompletes == this.totalParts)
            {
                trace("SplitFileLoader: 所有组件下载完毕 ");
                while (i < this.totalParts)
                {
                    
                    currentSwfStream = this.swfStreamArray[i].stream;
                    currentSwfStream.readBytes(this.swfData, this.swfData.bytesAvailable, 0);
                    currentSwfStream.close();
                    i = (i + 1);
                }
                splitLoaderCtx = new LoaderContext(false, ApplicationDomain.currentDomain);
                this.sfLoader.contentLoaderInfo.addEventListener(Event.INIT, function (event:Event) : void
            	{
	                dispatchEvent(new Event(Event.COMPLETE));
	                return;
            	});
                this.sfLoader.loadBytes(this.swfData, splitLoaderCtx);
            }
            return;
        }

        public function get content() : DisplayObject
        {
            return this.sfLoader.content;
        }

        public function streamError(event:IOErrorEvent) : void
        {
			Debug.log("SplitFileLoader: " + event.text);
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            return;
        }
		private function status(evt:HTTPStatusEvent):void{
			//if(evt.status!=200) Debug.log("Swf Server Error");;
		}
		private function error(evt:SecurityErrorEvent):void{
			Debug.log("SplitFileLoader: " + evt.text);
		}
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakRefences:Boolean = false) : void
        {
            this.dispatcher.addEventListener(type, listener, useCapture, priority);
            return;
        }

        public function dispatchEvent(event:Event) : Boolean
        {
            return this.dispatcher.dispatchEvent(event);
        }

        public function hasEventListener(type:String) : Boolean
        {
            return this.dispatcher.hasEventListener(type);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
        {
            this.dispatcher.removeEventListener(type, listener, useCapture);
            return;
        }

        public function willTrigger(type:String) : Boolean
        {
            return this.dispatcher.willTrigger(type);
        }

    }
}
