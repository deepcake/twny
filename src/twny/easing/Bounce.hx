package twny.easing;

@:final
class Bounce {

    static final n1 = 7.5625;
    static final d1 = 2.75;


    public static function easeIn(k:Float):Float {
        return 1 - inline easeOut(1 - k);
    }

    public static function easeInOut(k:Float):Float {
        return k < 0.5 ? (1 - inline easeOut(1 - 2 * k)) / 2 : (1 + inline easeOut(2 * k - 1)) / 2;
    }

    public static function easeOut(k:Float):Float {
        if (k < 1 / d1) {
            return n1 * k * k;
        } else if (k < 2 / d1) {
            return n1 * (k -= 1.5 / d1) * k + 0.75;
        } else if (k < 2.5 / d1) {
            return n1 * (k -= 2.25 / d1) * k + 0.9375;
        } else {
            return n1 * (k -= 2.625 / d1) * k + 0.984375;
        }
    }

}