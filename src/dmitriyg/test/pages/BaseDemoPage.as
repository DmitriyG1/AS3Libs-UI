/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.test.pages {
import dmitriyg.core.IDisposable;


import flash.display.Sprite;

public class BaseDemoPage extends Sprite implements IDisposable{

    private var _topPadding: Number = 0;

    public function BaseDemoPage() {
        super();
        createChildren();
    }

    protected function createChildren():void{

    }

    protected function makeThumbButton(thumbW: Number, thumbH: Number):Sprite{
        var btn:Sprite = new Sprite();
        btn.graphics.beginFill(0x0000FF);
        btn.graphics.drawRoundRect(0, 0, thumbW, thumbH, 8, 8);
        btn.graphics.endFill();
        btn.buttonMode = true;
        return btn;
    }


    public function get topPadding():Number {
        return _topPadding;
    }

    public function set topPadding(value:Number):void {
        _topPadding = value;
    }

    public function dispose():void {
    }
}
}
