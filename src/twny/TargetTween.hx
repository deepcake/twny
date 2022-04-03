package twny;

@:access(twny)
class TargetTween<T:Dynamic> extends Tween {

    var target:T;


    public function new(target:T, duration:Float) {
        this.target = target;
        super(duration);
    }


    override function stock() {
        if (!stocked) {
            Twny.addTween(this);
            Twny.addTargetTween(target, this);
            stocked = true;
        }
    }

    override function unstock() {
        stocked = false;
        Twny.removeTargetTween(target, this);
    }

}