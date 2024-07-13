package twny;

class TweenerTools {

    public static var instance(get, null):Tweener;


    public static inline function tween(duration:Float, autodispose = true) {
        return instance.tween(duration, autodispose);
    }

    public static inline function update(dt:Float) {
        instance.update(dt);
    }

    public static inline function reset() {
        instance.reset();
    }


    static function get_instance():Tweener {
        if (instance == null) {
            instance = new Tweener();
        }
        return instance;
    }

}