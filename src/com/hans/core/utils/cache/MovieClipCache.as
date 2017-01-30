package com.hans.core.utils.cache
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 让动画缓存数据在MovieClip中显示(只支持影片剪辑的主时间轴动画，不支持嵌套动画)
	 * 用完之后一定要记得stop();
	 * @author 翼翔天外
	 * 
	 */
	public class MovieClipCache extends MovieClip
	{
		private var _bmp:BitmapCache;
		private var _bitmapDataMovieCache:BitmapDataMovieCache;
		private var _currentFrame:int = 1;
		/**
		 * 
		 * @param bitmapDataMovieCache	位图缓存数据
		 * @param disableMouse			是否禁用鼠标
		 * 
		 */
		public function MovieClipCache(bitmapDataMovieCache:BitmapDataMovieCache,disableMouse:Boolean = true)
		{
			super();
			_bitmapDataMovieCache = bitmapDataMovieCache;
			_bmp = new BitmapCache(bitmapDataMovieCache.getBitmapDataCache(_currentFrame));//第一帧
			addChild(_bmp);
			this.mouseChildren = false;
			if(disableMouse)
			{
				this.mouseEnabled = false;
			}
			play();//自动播放，与显示对象默认操作相同
		}
		
		public function get bmp():BitmapCache
		{
			return _bmp;
		}

		private function startEnterFrame():void
		{
			_bitmapDataMovieCache.getMC().addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function stopEnterFrame():void
		{
			_bitmapDataMovieCache.getMC().removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			nextFrame();
		}
		
		/**
		 * 跳转显示到某一帧 
		 * @param frame
		 * 
		 */
		private function jumpFrame(frame:int):void
		{
			_bmp.bitmapDataCache = _bitmapDataMovieCache.getBitmapDataCache(frame);
			_currentFrame = frame;
		}
		
		/**
		 * 查找标签 
		 * @param labelName
		 * @return 
		 * 
		 */
		private function findLabel(labelName:String):FrameLabel
		{
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				if(label.name == labelName)
				{
					return label;
				}
			}
			return null;
		}
		
		//-------------------- 重写的方法和属性 --------------------
		override public function play():void
		{
			startEnterFrame();	
		}
		
		override public function stop():void
		{
			stopEnterFrame();
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			stop();
			if(frame is int)
			{
				jumpFrame(int(frame));
			}
			else
			{
				var label:FrameLabel = findLabel(String(frame));
				if(label != null)
				{
					jumpFrame(label.frame);
				}
				else
				{
					throw new Error("没有找到标签");
				}
			}	
		}
		
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			gotoAndStop(frame,scene);
			play();
		}
		
		override public function nextFrame():void
		{
			if(currentFrame >= totalFrames)
			{
				jumpFrame(1);
			}
			else
			{
				jumpFrame(currentFrame + 1);
			}
		}
		
		override public function prevFrame():void
		{
			if(currentFrame <= 1)
			{
				jumpFrame(totalFrames);
			}
			else
			{
				jumpFrame(currentFrame - 1);
			}
		}
		
		override public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		override public function get totalFrames():int
		{
			return _bitmapDataMovieCache.getMC().totalFrames;
		}
		
		override public function get currentLabel():String
		{
			var myLabel:String;
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				if(label.frame < currentFrame)
				{
					myLabel = label.name;
				}
			}			
			return myLabel;
		}
		
		override public function get currentLabels():Array
		{
			return _bitmapDataMovieCache.getMC().currentLabels;
		}
	}
}