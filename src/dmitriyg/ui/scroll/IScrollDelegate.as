/**
 * Created by dmitriy on 10.09.14.
 */
package dmitriyg.ui.scroll {
public interface IScrollDelegate {
    function onValueChanged(value:Number):void
    function onStartDragThumb():void
    function onStopDragThumb():void
}
}
