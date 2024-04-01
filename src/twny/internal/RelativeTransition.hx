package twny.internal;

class RelativeTransition extends Transition {

    var gett:Void->Float;
    var getf:Void->Float;


    @:noCompletion
    public function new(easing:Float->Float, getf:Void->Float, gett:Void->Float, set:Float->Void) {
        this.easing = easing;
        this.getf = getf;
        this.gett = gett;
        this.set = set;
    }

    function setup() {
        from = getf();
        to = gett();
    }

    function dispose() {
        easing = null;
        getf = null;
        gett = null;
        set = null;
    }

}