/**
 * Created by dmitriy on 28.03.15.
 */
package dmitriyg.ui.list {
public class ListController{

    private var _displayedItems:Array;
    private var _currentPosition:Number;
    private var _maxPosition:Number;
    private var _listRenderer: IListRenderer;
    private var _delegate: IListControllerDelegate;
    private var _positionField: String = "y";

    public function ListController(listRenderer: IListRenderer,
                                   positionField: String = "y") {
        super();

        _listRenderer = listRenderer;
        _positionField = positionField;
        _displayedItems = [];
        _currentPosition = 0;
    }

    // ==== public
    public function moveTo(position:Number):void{
        _maxPosition = this.cellSize * _listRenderer.getItemsCount() - this.componentSize;
        if(_maxPosition < 0){
            _maxPosition = 0;
        }

        _currentPosition = position;

        if(_currentPosition > _maxPosition){
            _currentPosition = _maxPosition;
        }

        if(_currentPosition < 0){
            _currentPosition = 0;
        }

        if(_delegate != null){
            _delegate.positionChanged(_currentPosition);
        }

        var itemIndex:int = getIndexAtPosition(0);

        var startY:Number = itemIndex * this.cellSize - _currentPosition;
        var count:int;
        var i:int;
        var displayedItem:IListCell;
        var currentItems: Array = [];
        //trace(this, "itemIndex:", 0, "startY:", startY);
        count = _displayedItems.length;
        var pos:Number;

        // кто будет удален
        var itemsToRemove: Array = [];
        for(i = 0; i < count; i++){
            displayedItem = _displayedItems[i];
            if(displayedItem.listData == null){
                trace(this, "Warning! list data is null. Item:", displayedItem);
                itemsToRemove.push(displayedItem);
                continue;
            }
            pos = int(displayedItem.listData.index) * this.cellSize - _currentPosition;
            if((pos + this.cellSize) < 0 || (pos > this.componentSize)){
                itemsToRemove.push(displayedItem);
            }
        }

        count = itemsToRemove.length;
        var index:int;
        for(i = 0; i < count; i++){
            index = _displayedItems.indexOf(itemsToRemove[i]);
            if(index < 0){
                trace(this, "Warning! Item to remove not found:", itemsToRemove[i]);
                continue;
            }
            _displayedItems.splice(index, 1);
            _listRenderer.removeItem(itemsToRemove[i]);
        }

        if(itemIndex < 0){
            trace(this, "Warning! Wrong itemIndex:", itemIndex, ", startY:", startY, ", pos:", _currentPosition);
            return;
        }

        while(startY < this.componentSize && itemIndex < _listRenderer.getItemsCount()){
            // ищем элемент в уже отображенных
            count = _displayedItems.length;
            displayedItem = null;
            for(i = 0; i < count; i++){
                displayedItem = _displayedItems[i];
                if(displayedItem.listData == null){
                    trace(this, "Warning! (while) list data is null. Item:", displayedItem);
                    itemsToRemove.push(displayedItem);
                    continue;
                }

                if(displayedItem.listData.index == itemIndex){
                    _displayedItems.splice(i, 1);
                    break;
                }else{
                    displayedItem = null;
                }
            }

            if(displayedItem == null){
                displayedItem = _listRenderer.addItemWithIndex(itemIndex) as IListCell;
            }

            currentItems.push(displayedItem);
            if( displayedItem.listData == null){
                displayedItem.listData = new ListData();
            }
            displayedItem.listData.index = itemIndex;
            displayedItem[_positionField] = startY;

            startY += this.cellSize;
            itemIndex++;
        }

        // delete
        count = _displayedItems.length;
        for(i = 0; i < count; i++){
            _listRenderer.removeItem(_displayedItems[i]);
        }

        _displayedItems = currentItems;
    }

    // TODO сделать новым массивом
    public function getDisplayedItems():Array{
        return _displayedItems;
    }

    public function get currentPosition():Number {
        return _currentPosition;
    }

    public function get maxPosition():Number {
        return _maxPosition;
    }


    public function get delegate():IListControllerDelegate {
        return _delegate;
    }

    public function set delegate(value:IListControllerDelegate):void {
        _delegate = value;
    }

    // ==== private
    private function get componentSize():Number{
        return _listRenderer.scrollSize;
    }

    private function getIndexAtPosition(pos:int):int{
        return Math.floor((_currentPosition + pos) / _listRenderer.cellSize);
    }

    private function get cellSize():Number{
        return  _listRenderer.cellSize;
    }


}
}
