package twny.easing;

@:final
class Expo {

    public static function easeIn(k:Float):Float {
        return k == 0 ? 0 : Math.pow(2, 10 * (k - 1));
    }

    public static function easeInOut(k:Float):Float {
        if (k == 0) { return 0; }
        if (k == 1) { return 1; }
        if ((k /= 1 / 2.0) < 1.0) {
            return 0.5 * Math.pow(2, 10 * (k - 1));
        }
        return 0.5 * (2 - Math.pow(2, -10 * --k));
    }

    public static function easeOut(k:Float):Float {
        return k == 1 ? 1 : (1 - Math.pow(2, -10 * k));
    }

}