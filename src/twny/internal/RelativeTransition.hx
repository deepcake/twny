package twny.internal;

class RelativeTransition extends Transition {


    var getTo:Void->Float;
    var getFr:Void->Float;


    @:noCompletion
    public function new(easing:Float->Float, getFr:Void->Float, getTo:Void->Float, set:Float->Void) {
        this.easing = easing;
        this.getFr = getFr;
        this.getTo = getTo;
        this.set = set;
    }

    function setup() {
        from = getFr();
        to = getTo();
    }

    function dispose() {
        easing = null;
        getFr = null;
        getTo = null;
        set = null;
    }

}