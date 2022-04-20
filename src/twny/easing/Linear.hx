package twny.easing;

@:final
class Linear {

    public static function easeNone(ratio:Float):Float {
        return ratio;
    }

    public static function easeStep(ratio:Float):Float {
        return ratio < 1 ? 0 : 1;
    }

}