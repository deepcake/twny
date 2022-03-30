package twny;

import hxease.IEasing;

class Transition {

    var easing:IEasing;

    var from:Float;
    var to:Float;

    var set:(value:Float)->Void;
    var get:Void->Float;


    public function new(easing:IEasing, to:Float, get:Void->Float, set:(value:Float)->Void) {
        this.easing = easing;
        this.to = to;
        this.get = get;
        this.set = set;
    }

    public function reset() {
        from = get();
    }

    public function apply(k:Float) {
        set(k < 1.0 ? from + (to - from) * easing.calculate(k) : to);
    }

}