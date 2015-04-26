/**
 * Created by dmitriy on 24.04.15.
 */
package dmitriyg.ui.list {
public interface IListRenderer {
    function addItemWithIndex(index:int):Object;
    function removeItem(itemVisual: Object):void;
    function getItemsCount():int;
    function get scrollSize():Number;
    function get cellSize():Number;
}
}
