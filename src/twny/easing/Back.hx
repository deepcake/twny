package twny.easing;

@:final
class Back {

    inline static var OVERSHOOT:Float = 1.70158;


    public static function easeIn(ratio:Float):Float {
        if (ratio == 1) return 1;
        return ratio * ratio * ((OVERSHOOT + 1.0) * ratio - OVERSHOOT);
    }

    public static function easeInOut(ratio:Float):Float {
        var over = OVERSHOOT;
        if ((ratio *= 2) < 1) {
            return 0.5 * (ratio * ratio * (((over *= (1.525)) + 1) * ratio - over));
        }
        return 0.5 * ((ratio -= 2) * ratio * (((over *= (1.525)) + 1) * ratio + over) + 2);
    }

    public static function easeOut(ratio:Float):Float {
        if (ratio == 0) return 0;
        return ((ratio = ratio - 1) * ratio * ((OVERSHOOT + 1) * ratio + OVERSHOOT) + 1);
    }

}