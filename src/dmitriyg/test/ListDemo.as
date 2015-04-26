/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.test {
import dmitriyg.ui.list.BaseListView;
import dmitriyg.ui.list.Cell;
import dmitriyg.ui.list.ListView;
import dmitriyg.ui.scroll.ScrollController;
import dmitriyg.ui.scroll.ScrollControllerWithTween;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

public class ListDemo extends Sprite{
    private var _list:ListView;
    private var _textFieldInput:TextField;
    private var _textFieldLog:TextField;

    public function ListDemo() {
        super();

        createChildren();
    }

    private function createChildren():void{
        this.graphics.beginFill(0xDDDDDD);
        this.graphics.drawRect(0, 0, 1024, 768);
        this.graphics.endFill();

        var scrollController:ScrollController = new ScrollControllerWithTween();

        _list = new ListView(Cell, scrollController);
        _list.x = 50;
        _list.y = 90;
        _list.height = 400;
        addChild(_list);
        //
        const padding:Number = 20;
        var scrollHitArea:Sprite = new Sprite();
        scrollHitArea.graphics.beginFill(0xAAAAAA);
        scrollHitArea.graphics.drawRoundRect(0, 0, 16, _list.height - padding * 2, 8, 8);
        scrollHitArea.graphics.endFill();
        scrollHitArea.x = _list.x + _list.width + 2;
        scrollHitArea.y = _list.y + padding;
        addChild(scrollHitArea);

        var thumb:Sprite = makeThumbButton(16, 26);
        thumb.x = scrollHitArea.x;
        thumb.y = scrollHitArea.y;
        addChild(thumb);

        scrollController.init(thumb, scrollHitArea, _list, ScrollController.VERTICAL);
        var data:Array = [];
        for(var i:int = 0; i < 150; i++){
            data.push("Item_" + i);

        }
        _list.setData(data);

        var btn:Sprite = makeButton();
        btn.x = _list.x + _list.width + 20;
        btn.y = _list.y;
        addChild(btn);

        btn.addEventListener(MouseEvent.CLICK, onScrollBtnClick);

        _textFieldInput = new TextField();
        _textFieldInput.width = 100;
        _textFieldInput.height = 40;
        _textFieldInput.type = TextFieldType.INPUT;
        _textFieldInput.border = true;
        _textFieldInput.x = btn.x + btn.width + 20;
        _textFieldInput.y = btn.y;
        addChild(_textFieldInput);

        _textFieldLog = new TextField();
        _textFieldLog.width = 100;
        _textFieldLog.height = 50;
        _textFieldLog.border = true;
        _textFieldLog.x = _textFieldInput.x;
        _textFieldLog.y = _textFieldInput.y + _textFieldInput.height + 20;
        addChild(_textFieldLog);

       // addHorizontalList(_list.x + _list.width + 50, 220);

        //addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private  function addHorizontalList(posX:Number, posY:Number):void{
        var scrollController:ScrollController = new ScrollController();

        var _horizontalList:ListView = new ListView(Cell, scrollController, 80, BaseListView.HORIZONTAL);
        _horizontalList.x = posX;
        _horizontalList.y = posY;
        _horizontalList.width = 400;
        _horizontalList.height = 40;
        addChild(_horizontalList);
        //
        const padding:Number = 20;
        var scrollHitArea:Sprite = new Sprite();
        scrollHitArea.graphics.beginFill(0xCCCCCC);
        scrollHitArea.graphics.drawRoundRect(0, 0, _horizontalList.width - padding * 2, 18, 8, 8);
        scrollHitArea.graphics.endFill();
        scrollHitArea.x = _horizontalList.x + padding;
        scrollHitArea.y = _horizontalList.y + _horizontalList.height;
        addChild(scrollHitArea);

        var thumb:Sprite = makeThumbButton(26, 16);
        thumb.x = scrollHitArea.x;
        thumb.y = scrollHitArea.y + 1;
        addChild(thumb);

        scrollController.init(thumb, scrollHitArea, _horizontalList, ScrollController.HORIZONTAL);

        // data
        var data:Array = [];
        for(var i:int = 0; i < 150; i++){
            data.push("Item_" + i);

        }

        _horizontalList.setData(data);
    }

    private function makeThumbButton(thumbW: Number, thumbH: Number):Sprite{
        var btn:Sprite = new Sprite();
        btn.graphics.beginFill(0x0000FF);
        btn.graphics.drawRoundRect(0, 0, thumbW, thumbH, 8, 8);
        btn.graphics.endFill();
        btn.buttonMode = true;
        return btn;
    }

    private function makeButton():Sprite{
        var btn:Sprite = new Sprite();
        btn.graphics.beginFill(0x0000FF);
        btn.graphics.drawRect(0, 0, 100, 50);
        btn.graphics.endFill();
        btn.buttonMode = true;
        return btn;
    }

    private function onScrollBtnClick(event:MouseEvent):void {

        if(_textFieldInput.text == null || _textFieldInput.text.length == 0){
            return;
        }

        var num:Number = Number(_textFieldInput.text);

        _list.moveTo(num);
        _textFieldLog.text = "max: " + _list.maxPosition;
        trace(this, "list max position:", _list.maxPosition);
    }


}
}
