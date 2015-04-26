/**
 * Created by dmitriy on 24.04.15.
 */
package dmitriyg.ui.list {
import dmitriyg.ui.core.BaseUIComponent;
import dmitriyg.ui.core.InvalidationType;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class BaseListView extends BaseUIComponent implements IListRenderer{
    protected var _cachedItems:Array;
    protected var _itemRenderer: Class;
    protected var _listController: ListController;
    protected var _data:Array;
    protected var _cellWithMouseOver: ICellRenderer;
    protected var _mouseGlobalPosition:Point;
    protected var _mask: Shape;
    protected var _cellSize:Number;

    public static const VERTICAL: String = "VERTICAL";
    public static const HORIZONTAL: String = "HORIZONTAL";

    private var _listType:String;

    private var _selectedIndex:int = -1;

    public function BaseListView(itemRenderer: Class,
                                 cellSize:Number = 40,
                                 listType:String = VERTICAL,
                                 listW: Number = 100,
                                 listH: Number = 200) {
        super ();

        _listType = listType;
        _itemRenderer = itemRenderer;
        _cellSize = cellSize;
        _height = listH;
        _width = listW;

        _cachedItems = [];

        _mouseGlobalPosition = new Point();

        var positionField:String;
        switch (listType){
            case VERTICAL:
                positionField = "y";
                break;
            case HORIZONTAL:
                positionField = "x";
                break;
            default:
                trace(this, "Warning! Unknown listType:", listType);
                return;
                break;
        }

        _listController = new ListController(this, positionField);

        addEventListener(MouseEvent.CLICK, onMouseClick);
        addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        addEventListener(MouseEvent.ROLL_OUT, onMouseMove);
        addEventListener(MouseEvent.ROLL_OVER, onMouseMove);
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

        invalidate(InvalidationType.SIZE);
    }

    // === override BaseUIComponent
    override protected function draw():void{
        super.draw();

        if(isInvalid(InvalidationType.SIZE)){
            drawBg();
            // обновить ячейки
            _listController.moveTo(_listController.currentPosition);
        }

        if(isInvalid(InvalidationType.STATE)){
            updateMouseState();
        }
    }

    override public function dispose():void{
        prepareToDispose();

        removeEventListener(MouseEvent.CLICK, onMouseClick);
        removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        removeEventListener(MouseEvent.ROLL_OUT, onMouseMove);
        removeEventListener(MouseEvent.ROLL_OVER, onMouseMove);
        removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

        super.dispose();
    }

    // === IListRenderer

    public function addItemWithIndex(index:int):Object{
        var item: ICellRenderer;
        //trace(this, "_cachedItems:", _cachedItems.length);
        if(_cachedItems.length > 0){
            item = _cachedItems[0];
            _cachedItems.splice(0, 1);
            // item["x"] = 105;
        }

        if(item == null){
            item = new _itemRenderer();
            //item["x"] = -105;
            //item["alpha"] = 0;
        }

        if(_listType == VERTICAL){
            (item as DisplayObject).width = _width;
            (item as DisplayObject).height = _cellSize;
        }else{
            (item as DisplayObject).width = _cellSize;
            (item as DisplayObject).height = _height;
        }

        item.data = _data[index];
        item.isSelected = index == _selectedIndex;
        //TweenLite.killTweensOf(item);
        //TweenLite.to(item, 0.5, {x: 0, alpha:1});
        addChild(item as DisplayObject);
        return item;
    }

    public function removeItem(itemVisual:Object):void {
        _cachedItems.push(itemVisual);
        //TweenLite.killTweensOf(itemVisual);

        if(itemVisual.parent != null){
            itemVisual.parent.removeChild(itemVisual);
            /*TweenLite.to(itemVisual, 0.5, {x: 105, alpha:0.5,
             onComplete:onCompleteHide,
             onCompleteParams:[itemVisual]});*/
        }
    }

    public function getItemsCount():int {
        if(_data != null){
            return _data.length;
        }

        return 0;
    }

    public function get scrollSize():Number {
        if(_listType == VERTICAL) {
            return this.height;
        }else{
            return this.width;
        }
    }

    public function get cellSize():Number {
        return _cellSize;
    }

    public function set cellSize(value:Number):void {
        _cellSize = value;
        invalidate(InvalidationType.SIZE);
    }

    // =========== private

    protected function drawBg():void{
        graphics.clear();
        graphics.beginFill(0x000000, 0.1);
        graphics.drawRect(0, 0, _width, _height);
        graphics.endFill();

        if(_mask == null){
            _mask = new Shape();
            addChild(_mask);
        }

        _mask.graphics.clear();
        _mask.graphics.beginFill(0x000000);
        _mask.graphics.drawRect(0, 0, _width, _height);
        _mask.graphics.endFill();

        this.mask = _mask;
    }

    // == public

    public function moveTo(pos:Number):void{
        //_listController.moveTo(pos);
        position = pos;
        //TweenLite.killTweensOf(this);
        //TweenLite.to(this, 0.5, {position: pos});
    }

    public function setData(data:Array, resetScroll:Boolean = false):void{
        _data = data;
        _listController.moveTo(resetScroll? 0 :_listController.currentPosition);

        selectedIndex = -1;
    }

    public function set position(val:Number):void{
        _listController.moveTo(val);
    }

    public function get position():Number {
        return _listController.currentPosition;
    }

    public function get maxPosition():Number {
        return _listController.maxPosition;
    }

    public function get listType():String {
        return _listType;
    }

    public function get selectedIndex():int {
        return _selectedIndex;
    }

    public function set selectedIndex(val: int):void {
         _selectedIndex = val;

        if(_data != null){

            if(_selectedIndex >= _data.length){
                _selectedIndex = _data.length - 1;
            }
        }else{
            _selectedIndex = -1;
        }

        setSelectedIndex(_selectedIndex);
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function onMouseClick(event:MouseEvent):void {

        var item:Object = event.target;

        while(!(item is ICellRenderer) && (item != null) && (item != this)){
            item = item.parent;
        }

        if( (item != null) && (item is ICellRenderer) ){
            onItemSelected(item as ICellRenderer);
            //trace(this, "Selected:", (item as IListCell).listData);
        }
    }

    protected function onItemSelected(selectedItem: ICellRenderer):void{
        if(selectedItem.listData != null){
            selectedIndex = selectedItem.listData.index;
        }else{
            selectedIndex = -1;
            trace(this, "Warning! onItemSelected() List data is null. Item:", selectedItem);
        }
    }

    private function setSelectedIndex(index:int):void{
        var displayedItems:Array = _listController.getDisplayedItems();

        var count:int = displayedItems.length;
        var item: ICellRenderer;
        for(var i:int = 0; i < count; i++){
            item = displayedItems[i];
            if(item.listData == null){
                trace(this, "Warning! setSelectedIndex() List data is null. Item:", item);
                continue;
            }
            item.isSelected = item.listData.index == index;
        }
    }


    private function updateMouseState():void{
        var partForMouseOver:ICellRenderer = null;
        var part:ICellRenderer;

        var mouseLocalPosition:Point = this.globalToLocal(_mouseGlobalPosition);

        if(mouseLocalPosition.x >= 0 && mouseLocalPosition.x <= _width &&
                mouseLocalPosition.y >= 0 && mouseLocalPosition.y <= _height){

            var displayedItems:Array = _listController.getDisplayedItems();

            var count:int = displayedItems.length;
            for(var i:int = 0; i < count; i++){
                part = displayedItems[i];
                if(part == null){
                    continue;
                }

                if((part as DisplayObject).hitTestPoint(_mouseGlobalPosition.x, _mouseGlobalPosition.y)){
                    partForMouseOver = part;
                    break;
                }
            }

            /*for(var i:int = 0; i < this.numChildren; i++){
                part = getChildAt(i) as ICellRenderer;
                if(part == null){
                    continue;
                }

                if((part as DisplayObject).hitTestPoint(_mouseGlobalPosition.x, _mouseGlobalPosition.y)){
                    partForMouseOver = part;
                }
            }*/
        }


        if(_cellWithMouseOver != partForMouseOver){
            if(_cellWithMouseOver != null){
                _cellWithMouseOver.setMouseState("out");
            }

            _cellWithMouseOver = partForMouseOver;

            if(_cellWithMouseOver != null){
                _cellWithMouseOver.setMouseState("over");
            }
        }

    }

    private function onMouseMove(event:MouseEvent):void {
        invalidate(InvalidationType.STATE);

        _mouseGlobalPosition.x = event.stageX;
        _mouseGlobalPosition.y = event.stageY;
    }


    private function onMouseWheel(event:MouseEvent):void {
        _listController.moveTo(_listController.currentPosition + event.delta);
        invalidate(InvalidationType.STATE);
    }

}
}
