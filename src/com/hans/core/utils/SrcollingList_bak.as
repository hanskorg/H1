package com.hans.core.utils {
	import com.greensock.TweenLite;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	

	public class SrcollingList_bak extends MovieClip
	{
		private var mElementsPool:Array;
		private var mDataList:Array;
		private var mElementClass:Class;
		private var mContainer:DisplayObjectContainer;
		private var mSrcollMode:Mode = Mode.HORIZONTAL;
		private var mWithAnimation:Mode = Mode.ANIMATION;
		private var mNumRows:uint = 1;
		private var mNumCols:uint = 10;
		private var mHorzontalSpace:uint = 10;
		private var mVertivalSpace:uint = 10;
		private var mCurrentPage:uint = 0;
		private var mPagesize:uint = 1;
		private var mCurrentIndex:uint = 0;
		private var mAnmitionLock:Boolean = false;
		
		public function SrcollingList_bak()
		{
			
		}
		public function setup(_data:Array,_contaioner:DisplayObjectContainer,_element:Class,_VSpace:uint=0,_HSpace:uint=0):void{
			if(this.mElementsPool && this.mElementsPool.length!=0){
				this.mCurrentPage = 0;
			}
			this.mVertivalSpace = _VSpace;
			this.mHorzontalSpace = _HSpace;
			this.mDataList = _data;
			this.mContainer = _contaioner;
			this.mElementClass = _element;
			this.mPagesize = this.mNumCols * this.mNumRows;
			updateElementsWithoutAnmi(0);
			//设置元素
		}
		private function updateElementsWithoutAnmi(_index:uint = 0):void{
			this.mCurrentIndex = _index;
			//去掉现在的显示元件
			for each(var __oldElement:ScrollingElement  in this.mElementsPool){
				if(__oldElement && __oldElement.parent){
					__oldElement.parent.removeChild(__oldElement);
				}
			}
//			while(this.mContainer.numChildren){
//				this.mContainer.removeChildAt(this.mContainer.numChildren-1);
//			}
			this.mElementsPool = new Array();
			//循环拿到数据并显示到列表中
			this.updateElements(_index);
		}
		private function updateElementsWithAnmi(_index:uint,_mode:int=0):void{
			this.updateElements(_index,_mode);
			this.mAnmitionLock = true;
			TweenLite.to(this.mContainer,0.5,{onComplete:complateAnmi,onCompleteParams:_mode});
		}
		private function updateElements(_index:uint,_mode:int=0){
			this.mCurrentIndex = _index;
			var __maxIndex = _index+this.mPagesize < this.mDataList.length ?  _index+this.mPagesize-1 : this.mDataList.length-1;
			var __currentIndex:uint = 0;
			for(var __i:uint= _index; __i<__maxIndex ; __i++ ){
				var __element:ScrollingElement = new this.mElementClass();
				__element.index = _index;
				__element.init(this.mDataList[__i]);
				var __currentRowNum:int = Math.floor(__i / this.mPagesize);
				var __currentColNum:int = __i % this.mPagesize;
				if(_mode==0){//不带缓动动画的填充
					__element.y = (__element.height + this.mHorzontalSpace) * __currentRowNum;
					__element.x = (__element.width + this.mVertivalSpace) * __currentColNum;//单个元件宽度×列宽
				}

				//如果向前
				if(this.mSrcollMode == Mode.VERTICAL)
					__element.x = __element.x  + this.mContainer.width*(_mode);

				//如果往回移动
				if(this.mSrcollMode == Mode.VERTICAL)
					__element.y = __element.y  + this.mContainer.height*(_mode);
					
				this.mElementsPool.push(__element);
				this.mContainer.addChild(__element);
				__currentIndex ++ ;
			}

		}
		/**
		 *@private 缓动结束触发函数 
		 * @param _mode 1正向移动，2纵向移动
		 * 
		 */		
		private function complateAnmi(_mode:int):void{
			if(_mode==1){
				var __sliceLength:uint = this.mElementsPool.length - this.mPagesize;
				if(__sliceLength>0)
					this.mElementsPool.splice(0,__sliceLength);
			}
			if(_mode==-1){
				var __sliceLength:uint = this.mElementsPool.length - this.mPagesize;
				if(__sliceLength>0)
					this.mElementsPool.splice(this.mPagesize,__sliceLength);
			}
			//if()
			this.mAnmitionLock = false;
		}
		public function scrollTo(_index:uint,_mode:int=0,_fouce:Boolean=false):Boolean{
			var __targetPage = Math.floor(_index / this.mPagesize);
			if(__targetPage == this.mCurrentPage) return false;//无须翻页
			if(this.mWithAnimation != Mode.NOANIMATION || _fouce){
				updateElementsWithoutAnmi(_index);
			}else{
				updateElementsWithAnmi(_index,_mode);
			}
			return true;
		}
		public function switchPage(_page:uint,mode:int):Boolean{
			
			if(this.mWithAnimation == Mode.ANIMATION && this.mAnmitionLock){
				return false;
			}
			if(_page *this.mPagesize > this.mDataList.length || _page<0 ||_page == this.mCurrentPage){
				return false;//指定页不存在,或者无须翻页
			}

		}
		public function pageNext():Boolean{
			if(this.mWithAnimation == Mode.ANIMATION && this.mAnmitionLock){
				return false;
			}
			if((this.mCurrentPage+1) *this.mPagesize > this.mDataList.length){
				return false;//指定页不存在
			}
			return this.scrollTo(this.mCurrentPage+1);
		}
		public function pagePre():Boolean{
			if(this.mWithAnimation == Mode.ANIMATION && this.mAnmitionLock){
				return false;
			}
			if(this.mCurrentPage<=0){
				return false;
			}
			return this.scrollTo(this.mCurrentPage-1);

		}
		public function set srcollMode(_mode:Mode):void{
			
		}
		/**
		 * 纵向距离 
		 * @param space uint
		 * 
		 */		
		public function set HSpace(space:uint):void{
			this.mHorzontalSpace = space;
		}
		
		public function set VSpace(space:uint):void{
			this.mVertivalSpace = space;	
		}
		
	}
	
}
class Mode {
	public static const HORIZONTAL : Mode = new Mode();
	public static const VERTICAL : Mode = new Mode();
	public static const ANIMATION : Mode = new Mode();
	public static const NOANIMATION : Mode = new Mode();
}