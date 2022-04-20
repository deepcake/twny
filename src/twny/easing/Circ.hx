package twny.easing;

@:final
class Circ {

    public static function easeIn(t:Float):Float {
        return -(Math.sqrt(1 - t * t) - 1);
    }

    public static function easeInOut(t:Float):Float {
        return t <= .5 ? (Math.sqrt(1 - t * t * 4) - 1) / -2 : (Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2;
    }

    public static function easeOut(t:Float):Float {
        return Math.sqrt(1 - (t - 1) * (t - 1));
    }

}