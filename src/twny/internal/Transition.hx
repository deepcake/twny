package twny.internal;

import hxease.IEasing;

class Transition {

    var easing:IEasing;

    var from:Float;
    var to:Float;

    var set:(value:Float)->Void;


    public function setup() {
        // nothing here
    }

    public function apply(k:Float) {
        set(k < 1.0 ? from + (to - from) * easing.calculate(k) : to);
    }

}