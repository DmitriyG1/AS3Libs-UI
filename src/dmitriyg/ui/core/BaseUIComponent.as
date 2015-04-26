/**
 * Created by dmitriy on 13.10.14.
 */
package dmitriyg.ui.core {
import dmitriyg.core.IDisposable;

import flash.display.Sprite;
import flash.events.Event;

/**
 * Базовый GUI компонент
 * Позволяет добавлять слушатели через класс org.osflash.signals.natives.NativeSignal
 *
 * Основной принцип работы при работе с компонентом.
 * Данный подход взят по аналогии с базовым компонентом fl.core.UIComponent
 *
 * 1. Если нужно изменить свойства, то меняем значение переменных. Но при этом не меняем сами
 * графические элементы.
 * 2. Аннулируем состояние элемента с помощью invalidate(). Свойства будут применены при следующем
 * событии EnterFrame
 * 3. Переопределяем метод draw(). В данном методе проверяем тип аннулированных свойств и применяем
 * соответсвующую логику
 *
 * Данный подход позволяет в одном методе draw() перерисовать и расположить в нужном порядке
 * все необходимые элементы раз за кадр.
 *
 * Для случая при многократном изменении свойст за время одного кадра - перерисовывает
 * элементы только один раз, при следующем событии EnterFrame
 *
 */
public class BaseUIComponent extends Sprite implements IDisposable{
    private var _invalidateType:uint;
    private var _disposed:Boolean = false;

    protected var _height:Number;
    protected var _width:Number;


    public function BaseUIComponent() {
        super();
        _width = 50;
        _height = 10;
    }

    // ====== override DisplayObject
    override public function get height():Number{
        return _height;
    }

    override public function set height(value:Number):void{
        _height = value;
        invalidate(InvalidationType.SIZE);
    }

    override public function get width():Number{
        return _width;
    }

    override public function set width(value:Number):void{
        _width = value;
        invalidate(InvalidationType.SIZE);
    }

    /**
     * Очищает обработчики событий, добавленные через addNativeSignal()
     */
    public function dispose():void {
        prepareToDispose();

        _invalidateType = 0;
        this.removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
    }

    /**
     * подготовка к очистке
     */
    protected function prepareToDispose():void{
        _disposed = true;
    }

    public function get isDisposed():Boolean{
        return _disposed;
    }

    /**
     * Аннулирует состояние компонента
     * @param invalidateType тип состояния, константы из класса InvalidationType
     */
    protected function invalidate(invalidateType:uint):void{
        _invalidateType |= invalidateType;
        this.addEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
    }

    /**
     * Обновление компонента
     * @param e
     */
    protected function onEnterFrameUpdate(e:Event):void {
        this.removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
        draw();
        _invalidateType = 0;
    }

    /**
     * Проверяет тип аннулированного состояния
     * @param invalidateType
     * @return
     */
    protected function isInvalid(invalidateType:uint):Boolean{
        return ((_invalidateType & invalidateType) > 0);
    }

    /**
     * Метод перерисовки компонента. Вызывается после каждого аннулирования состояния
     */
    protected function draw():void{
    }

    public function invalidateNow():void{
        onEnterFrameUpdate(null);
    }

    public function get disposed():Boolean {
        return _disposed;
    }

}
}
