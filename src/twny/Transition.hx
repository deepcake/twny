package twny;

import hxease.IEasing;

class Transition {

    var easing:IEasing;

    var from:Float;
    var to:Float;

    var st:(value:Float)->Void;
    var gt:Void->Float;


    public function new(easing:IEasing, to:Float, gt:Void->Float, st:(value:Float)->Void) {
        this.easing = easing;
        this.to = to;
        this.gt = gt;
        this.st = st;
    }

    public function reset() {
        from = gt();
    }

    public function apply(k:Float) {
        var value = k < 1.0 ? from + (to - from) * easing.calculate(k) : to;
        st(value);
    }


}