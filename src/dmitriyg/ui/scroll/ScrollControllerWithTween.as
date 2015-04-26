/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.ui.scroll {
import caurina.transitions.Tweener;

public class ScrollControllerWithTween extends ScrollController{
    private var _tweenDuration: Number;

    public function ScrollControllerWithTween(tweenDuration: Number = 0.2) {
        super();

        _tweenDuration = tweenDuration;
    }

    override protected function tweenThumbTo(pos: Number):void{
        Tweener.removeTweens(_thumb);
        var params:Object = {};
        params[_thumbPositionField] = pos;
        params["time"] = _tweenDuration;
        params["onComplete"] = onTweenComplete;
        params["onUpdate"] = onTweenUpdate;

        Tweener.addTween(_thumb, params);

        calculateValueByThumb();
    }

    private function onTweenUpdate():void {
        calculateValueByThumb();
    }

    private function onTweenComplete():void{
        calculateValueByThumb();

        if(_delegate != null){
            _delegate.onStopDragThumb();
        }
    }

    override protected function killTweens():void{
        Tweener.removeTweens(_thumb, true);

    }

}
}
