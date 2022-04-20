package twny.easing;

@:final
class Quint {

    public static function easeIn(k:Float):Float {
        return k * k * k * k * k;
    }

    public static function easeInOut(k:Float):Float {
        if((k *= 2) < 1) {
            return 0.5 * k * k * k * k * k;
        }
        return 0.5 * ((k -= 2) * k * k * k * k + 2);
    }

    public static function easeOut(k:Float):Float {
        return --k * k * k * k * k + 1;
    }

}