/**
 * Created by dmitriy on 28.03.15.
 */
package dmitriyg.test.components {
import dmitriyg.ui.list.*;
import dmitriyg.ui.core.BaseUIComponent;
import dmitriyg.ui.core.InvalidationType;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class DemoCell extends BaseUIComponent implements ICellRenderer{

    private var _listData:ListData;
    private var _data:Object;
    private var _tf:TextField;
    private var _mouseOver: Boolean;
    private var _isSelected: Boolean;

    public function DemoCell() {
        super();

        createChildren();
    }

    private function createChildren():void{
        var textFormat:TextFormat = new TextFormat();
        textFormat.align = TextFormatAlign.CENTER;
        _tf = new TextField();
        _tf.defaultTextFormat = textFormat;
        _tf.width = 10;
        _tf.mouseEnabled = false;
        addChild(_tf);

        drawBg();
    }

    override protected function draw():void{
        super.draw();

        if(isInvalid(InvalidationType.SIZE)){
            _tf.width = _width;
        }
        if(isInvalid(InvalidationType.SIZE) || isInvalid(InvalidationType.STATE)){
            if(_isSelected){
                _tf.textColor = 0xFFFFFF;
            }else{
                _tf.textColor = 0x000000;
            }
            drawBg();
        }

        if(isInvalid(InvalidationType.DATA)){
            _tf.height = _tf.textHeight + 10;
            _tf.y = (_height - _tf.height) * 0.5;
        }
    }

    private function drawBg():void{
        this.graphics.clear();
        this.graphics.lineStyle(1, 0xCCCCCC);

        if(_isSelected){
            this.graphics.beginFill(0x65CC7E);
        }else{
            if(_mouseOver){
                this.graphics.beginFill(0xFFCC99);
            }else{
                this.graphics.beginFill(0xFFFFCC);
            }
        }

        this.graphics.drawRect(0, 0, _width - 0.5, _height - 0.5);
        this.graphics.endFill();
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;

        _tf.text = _data == null ? "" : _data as String;

        invalidate(InvalidationType.DATA);
    }

    public function set listData(value:ListData):void {
        _listData = value;
    }

    public function get listData():ListData {
        return _listData;
    }


    public function setMouseState(state:String):void {
        if(_mouseOver != (state == "over")){
            _mouseOver = state == "over";
            invalidate(InvalidationType.STATE);
            invalidateNow();
        }
    }

    public function set isSelected(value:Boolean):void {
        if(_isSelected != value){
            _isSelected = value;
            invalidate(InvalidationType.STATE);
            invalidateNow();
        }
    }

    public function get isSelected():Boolean {
        return _isSelected;
    }
}
}
