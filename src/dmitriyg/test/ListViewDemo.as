/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.test {
import caurina.transitions.Tweener;
import dmitriyg.ui.list.BaseListView;
import dmitriyg.ui.list.ICellRenderer;

import flash.display.DisplayObject;

public class ListViewDemo extends BaseListView{
    public function ListViewDemo(itemRenderer: Class,
                                 cellSize:Number = 40,
                                 listType:String = VERTICAL,
                                 listW: Number = 100,
                                 listH: Number = 200) {
        super(itemRenderer, cellSize, listType, listW, listH);
    }

    override public function addItemWithIndex(index:int):Object{
        var item: ICellRenderer;
        //trace(this, "_cachedItems:", _cachedItems.length);
        if(_cachedItems.length > 0){
            item = _cachedItems[0];
            _cachedItems.splice(0, 1);
             item["x"] = 105;
        }

        if(item == null){
            item = new _itemRenderer();
            item["x"] = -105;
            item["alpha"] = 0;
        }

        if(listType == VERTICAL){
            (item as DisplayObject).width = _width;
            (item as DisplayObject).height = _cellSize;
        }else{
            (item as DisplayObject).width = _cellSize;
            (item as DisplayObject).height = _height;
        }

        item.data = _data[index];
        item.isSelected = index == selectedIndex;

        Tweener.removeTweens(item);
        Tweener.addTween(item, {time:0.5, x: 0, alpha:1});
        addChild(item as DisplayObject);
        return item;
    }

    override public function removeItem(itemVisual:Object):void {
        _cachedItems.push(itemVisual);

        Tweener.removeTweens(itemVisual);

        if(itemVisual.parent != null){
            Tweener.addTween(itemVisual, {
                time:0.5,
                x: 105,
                alpha:0.1,
             onComplete:onCompleteHide,
             onCompleteParams:[itemVisual]});
        }
    }


    private function onCompleteHide(itemVisual:DisplayObject):void{
        if(itemVisual.parent != null){
            // itemVisual.parent.removeChild(itemVisual);
        }
    }

    override protected function drawBg():void{
        graphics.clear();
        graphics.beginFill(0xFFFF00, 0.0);
        graphics.drawRect(0, 0, _width, _height);
        graphics.endFill();

        /*if(_mask == null){
            _mask = new Shape();
            addChild(_mask);
        }

        _mask.graphics.clear();
        _mask.graphics.beginFill(0x000000);
        _mask.graphics.drawRect(0, 0, _width, _height);
        _mask.graphics.endFill();

        this.mask = _mask;*/
    }

}
}
