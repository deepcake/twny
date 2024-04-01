package twny.internal;

abstract class Transition {

    var easing:Float->Float;

    var from:Float;
    var to:Float;

    var set:Float->Void;


    abstract function setup():Void;

    abstract function dispose():Void;


    function apply(k:Float) {
        var value = k < 1.0 ? from + (to - from) * easing(k) : to;
        set(value);
    }

}