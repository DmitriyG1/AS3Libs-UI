/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.test.pages {
import dmitriyg.test.components.DemoCell;
import dmitriyg.test.components.UISlider;
import dmitriyg.ui.list.BaseListView;
import dmitriyg.ui.list.ListView;
import dmitriyg.ui.scroll.ScrollController;
import dmitriyg.ui.scroll.ScrollControllerWithTween;

import flash.display.Sprite;
import flash.events.Event;

public class DemoHorizontalList extends BaseDemoPage{
    private var _list:ListView;
    private var _countDataSlider: UISlider;
    private var _thumb:Sprite;
    private var _scrollHitArea:Sprite;
    public function DemoHorizontalList() {
        super();
    }


    override protected function createChildren():void{
        var scrollController:ScrollController = new ScrollControllerWithTween();

        _list = new ListView(DemoCell, scrollController, 80,  BaseListView.HORIZONTAL);
        _list.x = 20;
        _list.y = 180;
        _list.width = 400;
        _list.height = 40;
        addChild(_list);
        //
        const padding:Number = 20;
        _scrollHitArea = new Sprite();
        _scrollHitArea.graphics.beginFill(0xAAAAAA);
        _scrollHitArea.graphics.drawRoundRect(0, 0, _list.width - padding * 2, 16, 8, 8);
        _scrollHitArea.graphics.endFill();
        _scrollHitArea.x = _list.x + padding;
        _scrollHitArea.y = _list.y + _list.height + 2;
        addChild(_scrollHitArea);

        _thumb = makeThumbButton(26, 16);
        _thumb.x = _scrollHitArea.x;
        _thumb.y = _scrollHitArea.y;
        addChild(_thumb);
        _thumb.alpha = 0.5;
        _thumb.mouseChildren = false;
        _thumb.mouseEnabled = false;
        _scrollHitArea.mouseEnabled = false;

        scrollController.init(_thumb, _scrollHitArea, _list, ScrollController.HORIZONTAL);

        _countDataSlider = new UISlider("Count:", 0, 20000, 0);
        _countDataSlider.x = 200;
        _countDataSlider.y = 80;

        addChild(_countDataSlider);
        _countDataSlider.addEventListener(Event.CHANGE, onCountChange);
    }

    private function onCountChange(event:Event):void {

        var val:int = Math.floor(_countDataSlider.value);

        // data
        var data:Array = [];
        for(var i:int = 0; i < val; i++){
            data.push("Item_" + i);
        }

        _list.setData(data);

        if(_list.cellSize * val > _list.scrollSize){
            _thumb.alpha = 1;
            _thumb.mouseEnabled = true;
            _scrollHitArea.mouseEnabled = true;
        }else{
            _thumb.alpha = 0.5;
            _thumb.mouseChildren = false;
            _thumb.mouseEnabled = false;
            _scrollHitArea.mouseEnabled = false;
        }

    }
}
}
