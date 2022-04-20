package twny.easing;

@:final
class Elastic {

    inline static var AMPLITUDE:Float = 0.1;
    inline static var PERIOD:Float = 0.4;


    public static function easeIn(k:Float):Float {
        if (k == 0) return 0;
        if (k == 1) return 1;
        var s = PERIOD / (2 * Math.PI) * Math.asin (1 / AMPLITUDE);
        return -(AMPLITUDE * Math.pow(2, 10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / PERIOD ));
    }

    public static function easeInOut(t:Float):Float {
        if (t == 0) {
            return 0;
        }
        if ((t /= 1 / 2) == 2) {
            return 1;
        }

        var p:Float = (0.3 * 1.5);
        var a:Float = 1;
        var s:Float = p / 4;

        if (t < 1) {
            return -0.5 * (Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p));
        }
        return Math.pow(2, -10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p) * 0.5 + 1;
    }

    public static function easeOut(t:Float):Float {
        if (t == 0) return 0;
        if (t == 1) return 1;
        var s = PERIOD / (2 * Math.PI) * Math.asin (1 / AMPLITUDE);
        return (AMPLITUDE * Math.pow(2, -10 * t) * Math.sin((t - s) * (2 * Math.PI) / PERIOD ) + 1);
    }

}