/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.ui.list {
import dmitriyg.ui.scroll.IScrollDelegate;
import dmitriyg.ui.scroll.ScrollController;

public class ListView extends BaseListView implements IScrollDelegate, IListControllerDelegate{

    private var _scrollController:ScrollController;

    public function ListView(itemRenderer: Class,
                             scrollController:ScrollController,
                             cellHeight:Number = 40,
                             listType:String = VERTICAL,
                             listW: Number = 100,
                             listH: Number = 200) {
        super(itemRenderer, cellHeight, listType, listW, listH);

        _scrollController = scrollController;
        _scrollController.delegate = this;
        _listController.delegate = this;
    }


    public function get scrollController():ScrollController {
        return _scrollController;
    }

    public function set scrollController(value:ScrollController):void {
        _scrollController = value;
        _scrollController.delegate = this;
    }

    public function onValueChanged(value:Number):void {
        _listController.moveTo(_listController.maxPosition * value);
    }

    public function onStartDragThumb():void {
        _listController.delegate = null;
    }

    public function onStopDragThumb():void {
        _listController.delegate = this;
    }


    public function positionChanged(value:Number):void {
        _scrollController.updateScrollValue(value / _listController.maxPosition);
    }
}
}
