package com.hans.core.utils.cache
{
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageQuality;

	/**
	 * 360度位图缓存数据 
	 * @author 翼翔天外
	 * 
	 */
	public class BitmapDataCache360 implements IDisposeAble
	{
		private var _target:DisplayObject;
		private var _stage:Stage;
		private var _cacheVector:Vector.<BitmapDataCache> = new Vector.<BitmapDataCache>(360,true);
		/**
		 * 
		 * @param target		要缓存的显示对象
		 * @param stage			舞台
		 * @param dynamicCache	是否动态缓存(当用到时才缓存)
		 * 
		 */
		public function BitmapDataCache360(target:DisplayObject,stage:Stage = null,dynamicCache:Boolean = true)
		{
			_target = target;
			_stage	= stage;
			if(!dynamicCache)
			{
				var oldQuality:String;
				if(stage != null)
				{
					oldQuality = stage.quality;
					stage.quality = StageQuality.BEST;
				}
				for(var i:int = 0 ; i < 360 ; i++)
				{
					_cacheVector[i] = new BitmapDataCache(_target,i);
				}
				if(stage != null)
				{
					stage.quality = oldQuality;
				}
			}
		}
		
		/**
		 * 获得角度缓存 
		 * @param rotation 角度
		 * @return 
		 * 
		 */
		public function getBitmapDataCache(rotation:int):BitmapDataCache
		{
			if(rotation < 0) rotation = 360 - Math.abs(rotation)%360;
			if(rotation >= 360) rotation %= 360;
			if(_cacheVector[rotation] == null)
			{
				_cacheVector[rotation] = new BitmapDataCache(_target,rotation,_stage);
			}
			return _cacheVector[rotation];
		}
		
		/**
		 *  释放资源
		 * 
		 */
		public function destroy():void
		{
			_target = null;
			_stage  = null;
			for(var i:int = 0 ; i < 360 ; i++)
			{
				if(_cacheVector[i] != null)
				{
					_cacheVector[i].destroy();
				}
			}
			_cacheVector = new Vector.<BitmapDataCache>(360,true);
		}
	}
}