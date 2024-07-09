package twny;

@:access(twny)
class Twny {

    static final updating = new Array<Tween>();


    public static function tween(duration:Float) {
        return new Tween(duration);
    }


    public static function update(dt:Float) {
        var l = updating.length;
        var i = 0;
        while (i < l) {
            var tween = updating[i];
            tween.update(dt);
            if (!tween.running) {
                tween.unstock();
                updating.splice(i, 1);
                l--;
            }
            else {
                i++;
            }
        }
    }

    public static function reset() {
        for (tween in updating) {
            if (tween.head != null) {
                tween.head.dispose();
            }
            else {
                tween.dispose();
            }
        }
        updating.resize(0);
    }


    static inline function addTween(tween:Tween) {
        updating.push(tween);
    }

}