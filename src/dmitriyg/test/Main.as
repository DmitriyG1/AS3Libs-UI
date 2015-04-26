/**
* Created by Dmitriy Gaiduk on 26.04.15.
*/
package dmitriyg.test {
import dmitriyg.test.components.MenuCell;
import dmitriyg.test.pages.BaseDemoPage;
import dmitriyg.test.pages.DemoHorizontalList;
import dmitriyg.test.pages.DemoVerticalList;
import dmitriyg.ui.list.BaseListView;

import flash.display.Sprite;
import flash.events.Event;
[SWF(
        width = "1024",
        height = "600",
        frameRate = "24",
        scaleMode="noScale",
        )]
public class Main extends Sprite{
    private var _currentPage:BaseDemoPage;
    private var _pageHolder:Sprite;
    private var _horizontalList:BaseListView;

    public function Main() {

        super();
        createChildren();
    }

    protected function createChildren():void{
        _pageHolder = new Sprite();
        addChild(_pageHolder);

        _horizontalList = new BaseListView(MenuCell, 80, BaseListView.HORIZONTAL);
        _horizontalList.x = 8;
        _horizontalList.y = 8;
        _horizontalList.width = 160;
        _horizontalList.height = 40;
        addChild(_horizontalList);

        _horizontalList.addEventListener(Event.CHANGE, onListChange);

       // data
        var data:Array = [];
        data.push("Vertical");
        data.push("Horizontal");
        //data.push("Cache demo");

        _horizontalList.setData(data);
        _horizontalList.selectedIndex = 0;
    }


    private function onListChange(event:Event):void {
       // trace(this, "onListChange");
        if(_currentPage != null && _currentPage.parent != null){
            _currentPage.parent.removeChild(_currentPage);
            _currentPage.dispose();
        }

        _currentPage = null;

        switch (_horizontalList.selectedIndex){
            case 0:
                _currentPage = new DemoVerticalList();
                break;
            case 1:
                _currentPage = new DemoHorizontalList();
                break;
        }

        if(_currentPage != null){
            _pageHolder.addChild(_currentPage);
        }
    }
}
}
