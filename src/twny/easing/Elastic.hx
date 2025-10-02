package twny.easing;

@:final
class Elastic {

    static final c4 = (2 * Math.PI) / 3;
    static final c5 = (2 * Math.PI) / 4.5;


    public static function easeIn(k:Float):Float {
        if (k == 0) return 0;
        if (k == 1) return 1;
        return -Math.pow(2, 10 * k - 10) * Math.sin((k * 10 - 10.75) * c4);
    }

    public static function easeInOut(k:Float):Float {
        if (k == 0) return 0;
        if (k == 1) return 1;

        if (k < .5) {
            return -(Math.pow(2, 20 * k - 10) * Math.sin((20 * k - 11.125) * c5)) / 2;
        }
        else {
            return (Math.pow(2, -20 * k + 10) * Math.sin((20 * k - 11.125) * c5)) / 2 + 1;
        }
    }

    public static function easeOut(k:Float):Float {
        if (k == 0) return 0;
        if (k == 1) return 1;
        return Math.pow(2, -10 * k) * Math.sin((k * 10 - 0.75) * c4) + 1;
    }

}