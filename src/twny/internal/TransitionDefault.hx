package twny.internal;

import hxease.IEasing;

class TransitionDefault implements Transition {

    var easing:IEasing;

    var from:Float;
    var to:Float;

    var getFrom:Void->Float;
    var set:(value:Float)->Void;


    public function new(easing:IEasing, getFrom:Void->Float, to:Float, set:(value:Float)->Void) {
        this.easing = easing;
        this.getFrom = getFrom;
        this.to = to;
        this.set = set;
    }

    public function reset() {
        from = getFrom();
    }

    public function apply(k:Float) {
        set(k < 1.0 ? from + (to - from) * easing.calculate(k) : to);
    }

}