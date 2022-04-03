package twny.internal;

import hxease.IEasing;

class DefaultTransition extends Transition {

    var getFr:Void->Float;


    function new(easing:IEasing, getFr:Void->Float, to:Float, set:(value:Float)->Void) {
        this.easing = easing;
        this.getFr = getFr;
        this.to = to;
        this.set = set;
    }

    override function reset() {
        from = getFr();
    }

}