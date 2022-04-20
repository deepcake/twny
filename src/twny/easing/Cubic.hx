package twny.easing;

@:final
class Cubic {

    public static function easeIn(ratio:Float):Float {
        return ratio * ratio * ratio;
    }

    public static function easeInOut(ratio:Float):Float {
        return ((ratio /= 1 / 2) < 1) ? 0.5 * ratio * ratio * ratio : 0.5 * ((ratio -= 2) * ratio * ratio + 2);
    }

    public static function easeOut(ratio:Float):Float {
        return --ratio * ratio * ratio + 1;
    }

}
