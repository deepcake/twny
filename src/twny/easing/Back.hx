package twny.easing;

@:final
class Back {

    static final c1 = 1.70158;
    static final c2 = c1 * 1.525;
    static final c3 = c1 + 1;


    public static function easeIn(k:Float):Float {
        return c3 * k * k * k - c1 * k * k;
    }

    public static function easeInOut(k:Float):Float {
        if (k < 0.5) {
            return (Math.pow(2 * k, 2) * ((c2 + 1) * 2 * k - c2)) / 2;
        }
        else {
            return (Math.pow(2 * k - 2, 2) * ((c2 + 1) * (k * 2 - 2) + c2) + 2) / 2;
        }
    }

    public static function easeOut(k:Float):Float {
        return 1 + c3 * Math.pow(k - 1, 3) + c1 * Math.pow(k - 1, 2);
    }

}