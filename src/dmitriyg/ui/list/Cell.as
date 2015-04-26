/**
 * Created by dmitriy on 28.03.15.
 */
package dmitriyg.ui.list {
import dmitriyg.ui.core.BaseUIComponent;
import dmitriyg.ui.core.InvalidationType;

import flash.text.TextField;

public class Cell extends BaseUIComponent implements ICellRenderer{

    private var _listData:ListData;
    private var _data:Object;
    private var _tf:TextField;
    private var _mouseOver: Boolean;
    private var _isSelected: Boolean;

    public function Cell() {
        super();

        createChildren();
    }

    private function createChildren():void{
        _tf = new TextField();
        _tf.width = 10;
        addChild(_tf);

        drawRect();
    }

    override protected function draw():void{
        super.draw();

        if(isInvalid(InvalidationType.SIZE)){
            _tf.width = _width;
        }
        if(isInvalid(InvalidationType.SIZE) || isInvalid(InvalidationType.STATE)){
            drawRect();
        }
    }

    private function drawRect():void{
        this.graphics.clear();
        this.graphics.lineStyle(1);
        if(_mouseOver || _isSelected){
            this.graphics.beginFill(0x00FF00, 0.2);
        }else{
            this.graphics.beginFill(0xFF0000, 0.2);
        }

        this.graphics.drawRect(0, 0, _width - 1, _height - 1);
        this.graphics.endFill();
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;

        _tf.text = _data == null ? "" : _data as String;
        _tf.height = _tf.textHeight + 10;
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
