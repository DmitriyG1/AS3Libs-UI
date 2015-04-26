/**
 * Created by dmitriy on 07.04.15.
 */
package dmitriyg.ui.list {
public interface ICellRenderer extends IListCell{
    function set data(value:Object):void;
    function set isSelected(value: Boolean):void;
    function get isSelected():Boolean;
    function setMouseState(state: String):void;
}
}
