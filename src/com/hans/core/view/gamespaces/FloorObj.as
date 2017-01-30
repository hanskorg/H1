//Created by Action Script Viewer - http://www.buraks.com/asv
package com.ciestudios.garage.features.gamespace
{
    import com.ciestudios.garage.model.UserItem;
    import flash.display.Sprite;
    import com.ciestudios.garage.components.ui.GameButton;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import com.ciegames.cartown.views.gamespace.Floor;
    import flash.events.MouseEvent;
    import com.ciegames.cartown.events.UserWorkerTaskEvent;
    import com.ciestudios.garage.events.AssetLoaderEvent;
    import com.ciegames.core.data.mediaload.service.CachedLoaderManager;
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.ciestudios.garage.events.FloorObjEvent;
    import flash.display.DisplayObject;
    import com.ciegames.cartown.locale.AssetURLManager;
    import flash.events.Event;
    import flash.display.PixelSnapping;
    import com.ciegames.cartown.utils.ColorLayering;
    import flash.geom.ColorTransform;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import com.ciegames.cartown.views.gamespace.*;

    public class FloorObj extends StageMember
    {

        public static const MOUSE_DOWN:String = "FloorObj.MOUSE_DOWN";

        protected var _userItem:UserItem;
        public var assetHolder:Sprite;
        public var assetId:int;
        public var buyingWithMoney:Boolean;
        public var buyingWithPoints:Boolean;
        private var _isDesk:Boolean;
        private var _isDeskObj:Boolean;
        public var desk:Sprite;
        private var _btnRotate:GameButton;
        private var _dragHilite:Shape;
        private var _isFunctionalItem:Boolean;
        private var _hitSprite:Sprite;
        private var _hitBoundBox:Rectangle;
        private var _centroid:Point;
        private var _topCenter:Point;
        private var _assetColorLayer:Bitmap;

        public function FloorObj(_arg1:int, _arg2:int, _arg3:int, _arg4:Boolean, _arg5:Boolean, _arg6:UserItem=null)
        {
            super(((_arg1 * Floor.tileSize.width) - 10), ((_arg2 * Floor.tileSize.width) - 10));
            _tilesWidth = _arg1;
            _tilesDepth = _arg2;
            _rot = _arg3;
            if (_arg6)
            {
                this.h = _arg6.xPos;
                this.v = _arg6.yPos;
            };
            this._isDesk = _arg4;
            if (_arg4)
            {
                this.desk = new Sprite();
                addChild(this.desk);
            };
            this._isDeskObj = _arg5;
            this._userItem = _arg6;
            this.turnVisual();
            this.mouseEnabled = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.addEventListener(UserWorkerTaskEvent.READY_TO_COLLECT, this.onTaskEvent, false, 0, true);
            this.addEventListener(UserWorkerTaskEvent.COLLECTED, this.onTaskEvent, false, 0, true);
            this.addEventListener(UserWorkerTaskEvent.CLEANED, this.onTaskEvent, false, 0, true);
            _depthSortPointOffset = new Point((Floor.tileSize.width * (sizeH / 2)), (Floor.tileSize.height * (sizeV / 2)));
        }

        public static function centerPointOffset(_arg1:FloorObj):Point
        {
            var _local2:int = _arg1.centerHIdx;
            var _local3:int = _arg1.centerVIdx;
            var _local4:int = (_local3 - _local2);
            var _local5:int = (_local3 + _local2);
            return (new Point((_local4 * 35), (_local5 * 17.5)));
        }


        public function set h(_arg1:int):void
        {
            _h = _arg1;
        }

        public function set v(_arg1:int):void
        {
            _v = _arg1;
        }

        public function set rot(_arg1:int):void
        {
            _rot = (_arg1 % 4);
            this.turnVisual();
        }

        public function get isDesk():Boolean
        {
            return (this._isDesk);
        }

        public function get isDeskObj():Boolean
        {
            return (this._isDeskObj);
        }

        public function get userItem():UserItem
        {
            return (this._userItem);
        }

        public function get uniqueID():String
        {
            if (this._userItem)
            {
                return (this._userItem.userItemID);
            };
            return (null);
        }

        public function set isFunctionalItem(_arg1:Boolean):void
        {
            this._isFunctionalItem = _arg1;
            this.buttonMode = _arg1;
        }

        public function get isFunctionalItem():Boolean
        {
            return (this._isFunctionalItem);
        }

        protected function displayAsset(_arg1:String):void
        {
            this.assetHolder.addEventListener(AssetLoaderEvent.COMPLETE, this.onAssetDisplay, false, 0, true);
            CachedLoaderManager.getInstance().getLoader(_arg1, this.assetHolder);
        }

        protected function onAssetDisplay(_arg1:AssetLoaderEvent):void
        {
            _arg1.currentTarget.removeEventListener(AssetLoaderEvent.COMPLETE, this.onAssetDisplay);
            var _local2:MovieClip = MovieClip((_arg1.asset as Loader).content);
            while (this.assetHolder.numChildren > 0)
            {
                this.assetHolder.removeChild(this.assetHolder.getChildAt(0));
            };
            this.assetHolder.addChild(_local2);
            if (_local2.totalFrames >= 4)
            {
                this.clearColorAsset();
                _local2.gotoAndStop((_rot + 1));
                this.colorAsset();
            };
            this.drawhitArea(this);
        }

        protected function drawhitArea(_arg1:DisplayObject):void
        {
            var _local3:BitmapData;
            if (this._hitSprite != null)
            {
                this.removeChild(this._hitSprite);
                this._hitSprite.graphics.clear();
            };
            var _local2:Rectangle = _arg1.getBounds(_arg1);
            if (((!(_local2.width)) || (!(_local2.height))))
            {
                return;
            };
            _local3 = new BitmapData(_local2.width, _local2.height, true, 0);
            _local3.draw(_arg1, new Matrix(1, 0, 0, 1, -(_local2.x), -(_local2.y)), null, null, null, false);
            _local3.threshold(_local3, _local3.rect, new Point(), ">", 0, 0xFFFF6600, 0xFFFFFFFF, false);
            var _local4:Vector.<uint> = _local3.getVector(_local3.rect);
            var _local5:uint = _local4.length;
            this._hitSprite = new Sprite();
            var _local6:uint = _local3.width;
            var _local7:Point = new Point(-1, -1);
            this._hitSprite.graphics.lineStyle(1, 0xFF00);
            var _local8:uint;
            while (_local8 < _local5)
            {
                if (((!((_local4[_local8] == 0))) && (!(((_local8 % _local6) == 0)))))
                {
                    if (_local7.x == -1)
                    {
                        this._hitSprite.graphics.moveTo((_local8 - (_local6 * int((_local8 / _local6)))), (_local8 / _local6));
                    };
                    _local7.x = (_local8 - (_local6 * int((_local8 / _local6))));
                    _local7.y = int((_local8 / _local6));
                }
                else
                {
                    if (_local7.x != -1)
                    {
                        this._hitSprite.graphics.lineTo(_local7.x, _local7.y);
                        _local7.x = (_local7.y = -1);
                    };
                };
                _local8 = (_local8 + 1);
            };
            this._hitSprite.x = _local2.x;
            this._hitSprite.y = _local2.y;
            this.addChild(this._hitSprite);
            this._hitSprite.visible = false;
            this.hitArea = this._hitSprite;
            this._hitBoundBox = this._hitSprite.getBounds(this);
            this._centroid = new Point((this._hitBoundBox.x + (this._hitBoundBox.width / 2)), (this._hitBoundBox.y + (this._hitBoundBox.height / 2)));
            this._topCenter = new Point((this._hitBoundBox.x + (this._hitBoundBox.width / 2)), (this._hitBoundBox.y + (this._hitBoundBox.height * 0.12)));
            _local3.dispose();
            _local3 = null;
            _local4 = null;
            this.dispatchEvent(new FloorObjEvent(FloorObjEvent.HIT_AREA_CREATED, this, false));
        }

        public function rotate():int
        {
            this.rot = (_rot + 1);
            return (_rot);
        }

        protected function turnVisual():void
        {
            var _local1:MovieClip;
            if (!this.assetHolder)
            {
                this.assetHolder = new Sprite();
                this.addChild(this.assetHolder);
                this.assetHolder.mouseEnabled = false;
                this.assetHolder.mouseChildren = false;
                this.displayAsset(AssetURLManager.getInstance().getDataURL((("items/it_" + this._userItem.itemID) + ".swf")));
            }
            else
            {
                this.clearColorAsset();
                _local1 = (this.assetHolder.getChildAt(0) as MovieClip);
                _local1.gotoAndStop((_rot + 1));
                this.colorAsset();
                this.drawhitArea(this);
            };
        }

        public function get centerHIdx():int
        {
            return (Math.floor(((sizeH - 1) / 2)));
        }

        public function get centerVIdx():int
        {
            return (Math.floor(((sizeV - 1) / 2)));
        }

        public function rotatedDeskLoc(_arg1:int, _arg2:int):Point
        {
            var _local3:int;
            var _local4:int;
            switch (_rot)
            {
                case 0:
                    _local3 = _arg1;
                    _local4 = _arg2;
                    break;
                case 1:
                    _local3 = ((_tilesDepth - 1) - _arg2);
                    _local4 = _arg1;
                    break;
                case 2:
                    _local3 = ((_tilesWidth - 1) - _arg1);
                    _local4 = ((_tilesDepth - 1) - _arg2);
                    break;
                case 3:
                    _local3 = _arg2;
                    _local4 = ((_tilesWidth - 1) - _arg1);
                    break;
            };
            return (new Point(_local3, _local4));
        }

        public function localDeskLoc(_arg1:int, _arg2:int):Point
        {
            var _local3:int;
            var _local4:int;
            var _local5:Point;
            switch (_rot)
            {
                case 0:
                    _local3 = (_arg1 - _h);
                    _local4 = (_arg2 - _v);
                    break;
                case 1:
                    _local3 = (_arg2 - _v);
                    _local4 = (((_h + _tilesDepth) - 1) - _arg1);
                    break;
                case 2:
                    _local3 = (((_h + _tilesWidth) - 1) - _arg1);
                    _local4 = (((_v + _tilesDepth) - 1) - _arg2);
                    break;
                case 3:
                    _local3 = (((_v + _tilesWidth) - 1) - _arg2);
                    _local4 = (_arg1 - _h);
                    break;
            };
            return (new Point(_local3, _local4));
        }

        protected function onDown(_arg1:MouseEvent):void
        {
            dispatchEvent(new Event(MOUSE_DOWN, true, true));
        }

        protected function onTaskEvent(_arg1:UserWorkerTaskEvent):void
        {
        }

        protected function colorAsset():void
        {
            var _local1:uint;
            var _local2:MovieClip;
            var _local3:Bitmap;
            var _local4:Bitmap;
            var _local5:Bitmap;
            var _local6:Sprite;
            if (this.userItem.hasColor)
            {
                _local1 = this.userItem.color;
                _local2 = (this.assetHolder.getChildAt(0) as MovieClip);
                if (!this._assetColorLayer)
                {
                    this._assetColorLayer = new Bitmap(null, PixelSnapping.NEVER, true);
                };
                if (_local2.paint)
                {
                    this._assetColorLayer.bitmapData = new BitmapData(_local2.paint.width, _local2.paint.height, true, 0);
                    _local3 = new Bitmap(new BitmapData(Math.ceil(_local2.paint.width), Math.ceil(_local2.paint.height), true, 0), PixelSnapping.NEVER, false);
                    _local3.bitmapData.draw(_local2.paint);
                    _local4 = ColorLayering.getHiBmp(_local3.bitmapData);
                    _local5 = ColorLayering.getShadBmp(_local3.bitmapData);
                    _local3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (_local1 >> 16), ((_local1 >> 8) & 0xFF), (_local1 & 0xFF), 0);
                    _local6 = new Sprite();
                    _local6.addChild(_local3);
                    _local6.addChild(_local5);
                    _local6.addChild(_local4);
                    this._assetColorLayer.bitmapData.draw(_local6);
                    this._assetColorLayer.smoothing = true;
                    _local2.paint.visible = false;
                    this._assetColorLayer.x = _local2.paint.x;
                    this._assetColorLayer.y = _local2.paint.y;
                    _local2.addChild(this._assetColorLayer);
                    _local4.bitmapData.dispose();
                    _local5.bitmapData.dispose();
                    _local3.bitmapData.dispose();
                };
            };
        }

        protected function clearColorAsset():void
        {
            var _local1:MovieClip;
            if (this._assetColorLayer)
            {
                _local1 = (this.assetHolder.getChildAt(0) as MovieClip);
                _local1.removeChild(this._assetColorLayer);
                this._assetColorLayer.bitmapData.dispose();
            };
        }

        public function hiliteOn():void
        {
            var _local1:GlowFilter = new GlowFilter(16777062, 1, 7, 7, 30, 2);
            this.filters = [_local1];
        }

        public function hiliteOff():void
        {
            this.filters = [];
        }

        public function dragHiliteOnOk():void
        {
            this.createDragHilite();
            var _local2 = this._dragHilite.graphics;
            with (_local2)
            {
                clear();
                lineStyle(8, 0xFF00);
                beginFill(0, 0);
                drawRect(0, 0, (sizeH * Floor.tileSize.width), (sizeV * Floor.tileSize.width));
            };
        }

        public function dragHiliteOnNotOk():void
        {
            this.createDragHilite();
            var _local2 = this._dragHilite.graphics;
            with (_local2)
            {
                clear();
                lineStyle(8, 0xFF0000);
                beginFill(0, 0);
                drawRect(0, 0, (sizeH * Floor.tileSize.width), (sizeV * Floor.tileSize.width));
            };
        }

        public function dragHiliteOff():void
        {
            if (this._dragHilite)
            {
                this.removeChild(this._dragHilite);
                this._dragHilite.graphics.clear();
                this._dragHilite = null;
            };
        }

        private function createDragHilite():void
        {
            if (!this._dragHilite)
            {
                this._dragHilite = new Shape();
                this._dragHilite.transform.matrix3D = new Matrix3D();
                this._dragHilite.transform.matrix3D.appendRotation(45, Vector3D.Z_AXIS);
                this._dragHilite.transform.matrix3D.appendRotation(60, Vector3D.X_AXIS);
                this._dragHilite.x = 35;
                this.addChildAt(this._dragHilite, 0);
            };
        }

        public function getWalkableCells():Vector.<Point>
        {
            return (new Vector.<Point>());
        }

        public function getLowerRightHandCorner():Point
        {
            return (new Point((this._h + this.sizeH), (this._v + this.sizeV)));
        }

        public function get centroid():Point
        {
            return (this._centroid);
        }

        public function get topCenter():Point
        {
            return (this._topCenter);
        }

        public function get hitSprite():Sprite
        {
            return (this._hitSprite);
        }

        public function get hitBoundBox():Rectangle
        {
            return (this._hitBoundBox);
        }

        public function die():void
        {
            if (this.assetHolder)
            {
                this.assetHolder.removeEventListener(AssetLoaderEvent.COMPLETE, this.onAssetDisplay);
            };
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.removeEventListener(UserWorkerTaskEvent.READY_TO_COLLECT, this.onTaskEvent);
            this.removeEventListener(UserWorkerTaskEvent.COLLECTED, this.onTaskEvent);
            this.removeEventListener(UserWorkerTaskEvent.CLEANED, this.onTaskEvent);
        }


    }
}//package com.ciestudios.garage.features.gamespace
