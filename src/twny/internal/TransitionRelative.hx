package twny.internal;

import hxease.IEasing;

class TransitionRelative implements Transition {

    var easing:IEasing;

    var from:Float;
    var to:Float;

    var getTo:Void->Float;
    var getFrom:Void->Float;
    var set:(value:Float)->Void;


    public function new(easing:IEasing, getFrom:Void->Float, getTo:Void->Float, set:(value:Float)->Void) {
        this.easing = easing;
        this.getFrom = getFrom;
        this.getTo = getTo;
        this.set = set;
    }

    public function reset() {
        from = getFrom();
        to = getTo();
    }

    public function apply(k:Float) {
        set(k < 1.0 ? from + (to - from) * easing.calculate(k) : to);
    }

}