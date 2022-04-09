package twny.internal;

import hxease.IEasing;

class DefaultTransition extends Transition {


    var getFr:Void->Float;


    @:noCompletion
    public function new(easing:IEasing, getFr:Void->Float, to:Float, set:(value:Float)->Void) {
        this.easing = easing;
        this.getFr = getFr;
        this.to = to;
        this.set = set;
    }

    function setup() {
        from = getFr();
    }

    function dispose() {
        easing = null;
        getFr = null;
        set = null;
    }

}