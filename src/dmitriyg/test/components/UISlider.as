/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.test.components {
import dmitriyg.ui.scroll.IScrollDelegate;
import dmitriyg.ui.scroll.ScrollController;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Keyboard;

public class UISlider extends Sprite implements IScrollDelegate{

    private var _valueTF:TextField;
    private var _scrollController:ScrollController;
    private var _min:Number;
    private var _max:Number;
    private var _value:Number;

    public function UISlider(title:String, min:Number, max:Number, initVal:Number) {
        super();

        _min = min;
        _max = max;
        //_value = initVal;

        createChildren(title);

        value = initVal;
    }

    private function createChildren(title:String):void{
        var textFix:Number = 8;
        var titleTF:TextField = new TextField();
        titleTF.text = title;
        titleTF.width = titleTF.textWidth + textFix;
        titleTF.height = titleTF.textHeight + textFix;
        titleTF.mouseEnabled = false;

        addChild(titleTF);

        _valueTF = new TextField();
        _valueTF.text = "";
        _valueTF.width = 60 + textFix;
        _valueTF.height = _valueTF.textHeight + textFix;
        _valueTF.mouseEnabled = true;
        _valueTF.type = TextFieldType.INPUT;
        _valueTF.border = true;
        _valueTF.x = titleTF.x + titleTF.width + 4;
        addChild(_valueTF);
        _valueTF.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardUp);

        const padding:Number = 4;

        var scrollHitArea:Sprite = new Sprite();
        scrollHitArea.graphics.beginFill(0xCCCCCC);
        scrollHitArea.graphics.drawRoundRect(0, 0, 200, 18, 8, 8);
        scrollHitArea.graphics.endFill();
        scrollHitArea.x = 0;
        scrollHitArea.y = titleTF.y + titleTF.height + padding;
        addChild(scrollHitArea);

        var thumb:Sprite = makeThumbButton(26, 16);
        thumb.x = scrollHitArea.x;
        thumb.y = scrollHitArea.y + 1;
        addChild(thumb);
        _scrollController = new ScrollController();

        _scrollController.init(thumb, scrollHitArea, this, ScrollController.HORIZONTAL);
    }

    private function makeThumbButton(thumbW: Number, thumbH: Number):Sprite{
        var btn:Sprite = new Sprite();
        btn.graphics.beginFill(0x0000FF);
        btn.graphics.drawRoundRect(0, 0, thumbW, thumbH, 8, 8);
        btn.graphics.endFill();
        btn.buttonMode = true;
        return btn;
    }


    public function get value():Number {
        return _value;
    }

    public function set value(value:Number):void {
        _value = value;

        if(_value < _min){
            _value = _min;
        }

        if(_value > _max){
            _value = _max;
        }

        _scrollController.updateScrollValue( (_value - _min)/(_max - _min));
        updateUI();
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function onValueChanged(value:Number):void {
        _value = _min + (_max - _min) * value;
        updateUI();
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function onStartDragThumb():void {
    }

    public function onStopDragThumb():void {
    }

    private function updateUI():void{
        const textFix:Number = 8;
        _valueTF.text = Math.floor(_value).toFixed(0);
        //_valueTF.width = _valueTF.textWidth + textFix;
        _valueTF.height = _valueTF.textHeight + textFix;
    }

    private function onKeyboardUp(event:KeyboardEvent):void {
        if(event.keyCode != Keyboard.ENTER){
            return;
        }
        var val: Number = Number(_valueTF.text);

        if(isNaN(val)){
            return;
        }

        value = val;
    }
}
}
