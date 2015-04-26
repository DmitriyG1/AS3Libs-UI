/**
 * Created by dmitriy on 26.04.15.
 */
package dmitriyg.ui.list {
public class ListData {
    private var _index:int;

    public function ListData() {
    }

    public function get index():int {
        return _index;
    }

    public function set index(value:int):void {
        _index = value;
    }
}
}
