package twny.easing;

@:final
class Sine {

    public static function easeIn(t:Float):Float {
        if(t == 1) return 1;
        return 1 - Math.cos(t * Math.PI * 0.5);
    }

    public static function easeInOut(k:Float):Float {
        return -0.5 * (Math.cos(Math.PI * k) - 1);
    }

    public static function easeOut(k:Float):Float {
        return Math.sin(k * (Math.PI * 0.5));
    }

}