/**
 * Created by dmitriy on 10.09.14.
 */
package dmitriyg.ui.scroll {
import dmitriyg.core.IDisposable;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * Представляет класс для управления ползунком в прокрутке
 * Изменения в классе передаются через делегат IScrollDelegate
 * Инициализация
 * thumb - ползунок
 * trackHitArea - область клика по полосе прокрутки.
 * Высота объекта trackHitArea определяет максимальную высоту прокрутки
 */
public class ScrollController implements IDisposable{

    protected var _thumb:Sprite;
    private var _trackHitArea:Sprite;

    // значения {0..1}
    private var _value:Number = 0.0;
    private var _dragBounds:Rectangle;

    protected var _delegate:IScrollDelegate;

    private var _stage:Stage;

    protected var _scrollType: String;
    protected var _thumbPositionField:String;
    protected var _thumbSizeField:String;
    protected var _thumbMouseField:String;

    protected var _boundsMinField:String;
    protected var _boundsMaxField:String;
    protected var _boundsValueField:String;


    public static const VERTICAL: String = "VERTICAL";
    public static const HORIZONTAL: String = "HORIZONTAL";

    public function ScrollController() {

    }

    public function init(thumb:Sprite, trackHitArea:Sprite,
                         delegate:IScrollDelegate,
                         scrollType: String = VERTICAL):void{
        dispose();


        _value = 0;
        _thumb = thumb;
        _trackHitArea = trackHitArea;
        _scrollType = scrollType;

        switch(scrollType){
            case HORIZONTAL:
                _thumbPositionField = "x";
                _thumbSizeField = "width";
                _thumbMouseField = "mouseX";
                _boundsMinField = "left";
                _boundsMaxField = "right";
                _boundsValueField = "width";

                _dragBounds = new Rectangle(thumb.x, thumb.y,
                        _trackHitArea.width - getThumbSize(),
                        0);
                break;
            case VERTICAL:
                _thumbPositionField = "y";
                _thumbSizeField = "height";
                _thumbMouseField = "mouseY";
                _boundsMinField = "top";
                _boundsMaxField = "bottom";
                _boundsValueField = "height";

                _dragBounds = new Rectangle(thumb.x, thumb.y, 0,
                        _trackHitArea.height - getThumbSize());
                break;
            default:
                    trace(this, "Warning! Unknown scrollType:", scrollType);
                    return;
                break;
        }


        _thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
        _trackHitArea.addEventListener(MouseEvent.CLICK, onTrackMouseClickVertical);

        _delegate = delegate;
    }

    public function dispose():void{
        _delegate = null;

        killTweensAndStopThumbDrag();

        if(_thumb != null){
            _thumb.stopDrag();
            _thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
        }
        _thumb = null;

        if(_stage != null){
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        _stage = null;

        if(_trackHitArea != null){
            _trackHitArea.removeEventListener(MouseEvent.CLICK, onTrackMouseClickVertical);
        }
        _trackHitArea = null;

        _delegate = null;
    }


    private function onThumbMouseDown(event:MouseEvent):void {
        if(_thumb.stage == null){
            return;
        }

        killTweensAndStopThumbDrag();

        if(_delegate != null){
            _delegate.onStartDragThumb();
        }


        _trackHitArea.removeEventListener(MouseEvent.CLICK, onTrackMouseClickVertical);

        _stage = _thumb.stage;
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        _stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        _thumb.startDrag(false, _dragBounds);
    }

    private function onMouseMove(event:MouseEvent):void {
        // update value
        calculateValueByThumb();
    }

    private function onMouseUp(event:MouseEvent):void {
        if(_delegate != null){
            _delegate.onStopDragThumb();
        }

        _thumb.stopDrag();
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        _trackHitArea.addEventListener(MouseEvent.CLICK, onTrackMouseClickVertical);
    }


    protected function  calculateValueByThumb():void{
        this.value = (_thumb[_thumbPositionField] - _dragBounds[_boundsMinField]) / _dragBounds[_boundsValueField];

        //return _calculateValueByThumb;
    }

   /* private function calculateValueByThumbWithY():void{
        this.value = (_thumb.y - _dragBounds.top) / _dragBounds.height;
    }

    private function calculateValueByThumbWithX():void{
        this.value = (_thumb.x - _dragBounds.left) / _dragBounds.width;
    }*/

    public function get value():Number {
        return _value;
    }

    public function set value(value:Number):void {
        _value = value;

        if(_delegate != null){
            _delegate.onValueChanged(_value);
        }
    }

    public function get delegate():IScrollDelegate {
        return _delegate;
    }

    public function set delegate(value:IScrollDelegate):void {
        _delegate = value;
    }

    private function onTrackMouseClickVertical(event:MouseEvent):void {
        killTweensAndStopThumbDrag();

        if(_delegate != null){
            _delegate.onStartDragThumb();
        }

        var pos:Number;

        pos = _thumb.parent[_thumbMouseField] - getThumbSize() * 0.5;

        if(pos < _dragBounds[_boundsMinField]){
            pos = _dragBounds[_boundsMinField];
        }

        if(pos > _dragBounds[_boundsMaxField]){
            pos = _dragBounds[_boundsMaxField];
        }

       /* switch(_scrollType){
            case VERTICAL:
                pos = _thumb.parent.mouseY - getThumbSize() * 0.5;

                if(pos < _dragBounds.top){
                    pos = _dragBounds.top;
                }

                if(pos > _dragBounds.bottom){
                    pos = _dragBounds.bottom;
                }
                break;
            case HORIZONTAL:
                pos = _thumb.parent.mouseX - getThumbSize() * 0.5;

                if(pos < _dragBounds.left){
                    pos = _dragBounds.left;
                }

                if(pos > _dragBounds.right){
                    pos = _dragBounds.right;
                }
                break;
            default:
                trace(this, "Warning! Unknown scrollType:", _scrollType);
                break;
        }*/

        tweenThumbTo(pos);
    }

    protected function tweenThumbTo(pos: Number):void{
        /*switch(_scrollType){
            case VERTICAL:
                _thumb.y = pos;
                break;
            case HORIZONTAL:
                _thumb.x = pos;
                break;
            default:
                trace(this, "Warning! Unknown scrollType:", _scrollType);
                break;
        }*/

        _thumb[_thumbPositionField] = pos;

        calculateValueByThumb();
    }


    public function updateScrollValue(value: Number):void{
        if(_thumb == null){
            return;
        }

        _value = value;

        if(isNaN(_value)){
            _value = 0;
        }

        if(_value < 0){
            _value = 0;
        }

        if(_value > 1){
            _value = 1;
        }

        killTweensAndStopThumbDrag();

        switch(_scrollType){
            case VERTICAL:
                _thumb.y = _dragBounds.top + _value * _dragBounds.height;
                break;
            case HORIZONTAL:
                _thumb.x = _dragBounds.left + _value * _dragBounds.width;
                break;
            default:
                trace(this, "Warning! Unknown scrollType:", _scrollType);
                break;
        }
    }


    protected function killTweens():void{

    }
    private function killTweensAndStopThumbDrag():void{

        killTweens();

        if(_delegate != null){
            _delegate.onStopDragThumb();
        }
    }


    private function getThumbSize():Number{
        return _thumb[_thumbSizeField];
    }

}
}
