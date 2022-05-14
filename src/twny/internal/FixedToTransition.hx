package twny.internal;

class FixedToTransition extends Transition {


    var getf:Void->Float;


    @:noCompletion
    public function new(easing:Float->Float, getf:Void->Float, to:Float, set:Float->Void) {
        this.easing = easing;
        this.getf = getf;
        this.to = to;
        this.set = set;
    }

    function setup() {
        from = getf();
    }

    function dispose() {
        easing = null;
        getf = null;
        set = null;
    }

}