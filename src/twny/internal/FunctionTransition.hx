package twny.internal;

class FunctionTransition extends Transition {


    @:noCompletion
    public function new(easing:Float->Float, from:Float, to:Float, set:Float->Void) {
        this.easing = easing;
        this.from = from;
        this.to = to;
        this.set = set;
    }

    function setup() {
        // nothig here
    }

    function dispose() {
        easing = null;
        set = null;
    }

}