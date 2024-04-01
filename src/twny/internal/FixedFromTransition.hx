package twny.internal;

class FixedFromTransition extends Transition {

    var gett:Void->Float;


    @:noCompletion
    public function new(easing:Float->Float, from:Float, gett:Void->Float, set:Float->Void) {
        this.easing = easing;
        this.from = from;
        this.gett = gett;
        this.set = set;
    }

    function setup() {
        to = gett();
    }

    function dispose() {
        easing = null;
        gett = null;
        set = null;
    }

}