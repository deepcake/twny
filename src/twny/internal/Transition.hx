package twny.internal;

class Transition {


    var easing:Float->Float;

    var from:Float;
    var to:Float;

    var set:Float->Void;

    var getTo:Void->Float;
    var getFrom:Void->Float;


    @:noCompletion
    public function new(easing:Float->Float, getFrom:Void->Float, getTo:Void->Float, set:Float->Void) {
        this.easing = easing;
        this.getFrom = getFrom;
        this.getTo = getTo;
        this.set = set;
    }

    function setup() {
        from = getFrom();
        to = getTo();
    }

    function dispose() {
        easing = null;
        getFrom = null;
        getTo = null;
        set = null;
    }

    function apply(k:Float) {
        var value = k < 1.0 ? from + (to - from) * easing(k) : to;
        set(value);
    }

}