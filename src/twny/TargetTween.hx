package twny;

@:access(twny)
class TargetTween<T:Dynamic> extends Tween {


    var target:T;


    public function new(target:T, duration:Float) {
        super(duration);
        this.target = target;
        Twny.addTargetTween(target, this);
    }

    override function dispose() {
        Twny.removeTargetTween(target, this);
        super.dispose();
    }

}