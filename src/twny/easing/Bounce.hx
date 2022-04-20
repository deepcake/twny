package twny.easing;

@:final
class Bounce {

    static inline var B1:Float = 1 / 2.75;
    static inline var B2:Float = 2 / 2.75;
    static inline var B3:Float = 1.5 / 2.75;
    static inline var B4:Float = 2.5 / 2.75;
    static inline var B5:Float = 2.25 / 2.75;
    static inline var B6:Float = 2.625 / 2.75;


    public static function easeIn(ratio:Float):Float {
        ratio = 1 - ratio;
        if (ratio < B1) return 1 - 7.5625 * ratio * ratio;
        if (ratio < B2) return 1 - (7.5625 * (ratio - B3) * (ratio - B3) + .75);
        if (ratio < B4) return 1 - (7.5625 * (ratio - B5) * (ratio - B5) + .9375);
        return 1 - (7.5625 * (ratio - B6) * (ratio - B6) + .984375);
    }

    public static function easeInOut(ratio:Float):Float {
        if (ratio < .5) {
            ratio = 1 - ratio * 2;
            if (ratio < B1) return (1 - 7.5625 * ratio * ratio) / 2;
            if (ratio < B2) return (1 - (7.5625 * (ratio - B3) * (ratio - B3) + .75)) / 2;
            if (ratio < B4) return (1 - (7.5625 * (ratio - B5) * (ratio - B5) + .9375)) / 2;
            return (1 - (7.5625 * (ratio - B6) * (ratio - B6) + .984375)) / 2;
        }
        ratio = ratio * 2 - 1;
        if (ratio < B1) return (7.5625 * ratio * ratio) / 2 + .5;
        if (ratio < B2) return (7.5625 * (ratio - B3) * (ratio - B3) + .75) / 2 + .5;
        if (ratio < B4) return (7.5625 * (ratio - B5) * (ratio - B5) + .9375) / 2 + .5;
        return (7.5625 * (ratio - B6) * (ratio - B6) + .984375) / 2 + .5;
    }

    public static function easeOut(ratio:Float):Float {
        if (ratio < B1) return 7.5625 * ratio * ratio;
        if (ratio < B2) return 7.5625 * (ratio - B3) * (ratio - B3) + .75;
        if (ratio < B4) return 7.5625 * (ratio - B5) * (ratio - B5) + .9375;
        return 7.5625 * (ratio - B6) * (ratio - B6) + .984375;
    }

}