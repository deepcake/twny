package twny.internal;

import hxease.IEasing;

abstract class Transition {


    var easing:IEasing;

    var from:Float;
    var to:Float;

    var set:(value:Float)->Void;


    abstract function setup():Void;


    function apply(k:Float) {
        var value = k < 1.0 ? from + (to - from) * easing.calculate(k) : to;
        set(value);
    }

}