package com.hans.core.display.components
{
	import com.greensock.TweenLite;
	import com.hans.core.utils.Debug;
	import com.hans.core.utils.DrawUitl;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 *HList.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2012-5-27
	 */
	public class HList extends Sprite
	{
		private var _dataList:Array;
		public var weightList:Vector.<HElement>;
		public var currentIndex:uint=0;
		public var pageSize:uint=5;
		
		private var _Xoffset:int = 0;
		private var _Yoffset:int = 0;
		private var rowNum:int = 0;
		private var colsNum:int = 0;
		private var weight:Class;
		
		private var _container:DisplayObjectContainer;
		
		private var motion:HListMode = HListMode.ANIMATION;
		private var direction:HListMode = HListMode.VERTICAL;
		
		public function HList(container:DisplayObjectContainer,weight:Class,rowNum:uint=1,colsNum:uint=5,Xoffset:int=0,Yoffset:int=0,mode:HListMode=null,motion:HListMode = null)
		{
			pageSize = rowNum * colsNum;
			this.rowNum = rowNum;
			this.colsNum = colsNum;
			this._Xoffset = Xoffset;
			this._Yoffset = Yoffset;
			_container = container;
			this.weight = weight;
			//添加容器遮罩
			var mask:Sprite = DrawUitl.drawRect(100,100);
//			container.mask = mask;
			this.direction = mode ? mode : HListMode.VERTICAL;
			this.motion = motion ? motion : HListMode.ANIMATION;
		}
		/**
		 * 更新数据，一般用于初始化以及分类修改 
		 * @param data
		 * @param startIndex
		 * 
		 */		
		public function update(data:Object,startIndex:int=0):void
		{
			clear();
			weightList = new Vector.<HElement>();
			_dataList = [];
			if(!data.hasOwnProperty("length"))
			{
				Debug.warning("列表容器不是数组也不是Vector,可能会导致HList组件显示异常");
			}
			var sum:int = data.length;
			var index:int = 0;
			for each(var elementData:* in data)
			{
				_dataList.push(elementData);
				var weight:HElement = new weight as HElement;
				sum = _dataList.length - 1;
				/**横排列表*/
				if(this.direction == HListMode.VERTICAL){
					weight.x = (sum% this.colsNum + Math.floor(sum/ this.pageSize)*this.colsNum) * weight.width + this._Xoffset;
					weight.y = Math.floor(sum% this.rowNum) * weight.height + this._Yoffset;
				}else{
					weight.x = (sum% this.colsNum) * weight.width + this._Xoffset;
					weight.y = Math.floor(sum% this.rowNum + Math.floor(sum / this.pageSize)*this.rowNum) * weight.height + this._Yoffset;
				}
				(weight as IHElement).initData(this._dataList[index]);
				this.weightList.push(weight);
				
			}
			/**如果开始索引为-1，那么采用前一个UI的索引*/
			if(startIndex!=-1)
			{
				currentIndex = startIndex;
			}
			this.scrollTo(currentIndex);
		}
		public function scrollTo(index:int):void
		{
			/**如果偏移索引==当前索引，选择替换填充*/
			index = Math.max(0,index);
			var endIndex:int = Math.min(index+pageSize,this._dataList.length-1);
			/**不带缓动动画的*/
			if(this.motion == HListMode.NOANIMATION)
			{
				this.unRenderAll();
				this.render(index,endIndex);
				currentIndex = index;
			}else{
				/**带动画的*/
				/**修正开始位置*/
				index = Math.min(index,this._dataList.length - this.pageSize -1);
				if(currentIndex == index) return;//如果不需要偏移
				render(index,endIndex);
				/**向后移动*/
				if(currentIndex < index)
				{
					//上下缓动
					if(this.direction == HListMode.VERTICAL)
					{
						//缓动，container X左移
						var offestX:Number = 0;
						TweenLite.to(this._container,0.5,{x:x-offestX});						
					}else{
						var offsetY:Number = 0;
						TweenLite.to(this._container,0.5,{y:y - offsetY});
					}
				}
				/**向前移动*/
				if(currentIndex > index)
				{
					//缓动，container X右移
				}
			}
		}
		public function pageNext():void
		{
			
		}
		public function pagePre():void
		{
			
		}
		public function pageFirst():void
		{
			
		}
		public function pageEnd():void
		{
			
		}
		/**
		 *清除当前列表数据 
		 * 
		 */		
		public function clear():void
		{
			for each(var weight:HElement in this.weightList)
			{
				weight.dispose();	
			}
			weightList = null;
			this._dataList = null;
			//to-do
				//重置数据
				//清楚视图
				//删除监听
		}
		public function dispose():void
		{
			
		}
		private function render(startIndex:uint,endIndex:uint):void
		{
			if(startIndex < endIndex){
				for(var i:int=startIndex ; i<= endIndex ; i++){
					this._container.addChild(this.weightList[i]);
				}
			}
		}
		/**
		 * 清除制定位置的列表项 
		 * @param index 开始索引
		 * @param count 删除个数
		 * 
		 */		
		private function unRender(index:uint,count:uint=0):void
		{
			var endIndex:int = 0 ? this.weightList.length - 1 : index + count;
			for(var i:int=index; i < endIndex ; i++)
			{
				if(weightList[i].parent)
					_container.removeChild(weightList[i]);
			}
		}
		/**
		 *清楚当前显示列表中所有数据 
		 * 
		 */		
		private function unRenderAll():void
		{
			while(this._container.numChildren){
				this._container.removeChildAt(0);
				//weight.dispose();
			}

		}
		/**
		 * 缓动完成执行操作 
		 * @param index
		 * 
		 */		
		private function tweenComplete(index:uint):void
		{
			if(this.currentIndex < index){
				unRender(this.currentIndex,index-1);
			}else{
				var endIndex:uint = Math.min(index+this.pageSize,this._dataList.length - this.pageSize);
				unRender(index+1,endIndex);
			}
			this.currentIndex = index;
		}
		
	}
}