package twny;

import haxe.ds.ObjectMap;
import haxe.ds.List;

using Lambda;

@:access(twny)
class Twny {


    static var targetToTweenList = new ObjectMap<{}, List<Tween>>();

    static var updating = new Array<Tween>();


    overload extern inline public static function tween<T:{}>(target:T, duration:Float) {
        return new TargetTween(target, duration);
    }

    overload extern inline public static function tween(duration:Float) {
        return new Tween(duration);
    }


    public static function start(target:{}) {
        inline forEachTargetTween(target, t -> t.start());
    }

    public static function stop(target:{}, complete = false) {
        inline forEachTargetTween(target, t -> t.stop(complete));
    }

    public static function dispose(target:{}) {
        inline forEachTargetTween(target, t -> t.dispose());
    }

    public static function pause(target:{}) {
        inline forEachTargetTween(target, t -> t.pause());
    }

    public static function resume(target:{}) {
        inline forEachTargetTween(target, t -> t.resume());
    }


    public static function update(dt:Float) {
        var l = updating.length;
        var i = 0;
        while (i < l) {
            var tween = updating[i];
            tween.update(dt);
            if (!tween.running) {
                tween.unstock();
                updating.splice(i, 1);
                l--;
            }
            else {
                i++;
            }
        }
    }

    public static function reset() {
        for (tween in updating) {
            tween.dispose();
        }
        updating.resize(0);

        [ for (list in targetToTweenList) list ].iter(list -> {
            for (tween in list) {
                tween.dispose();
            }
        });
        targetToTweenList.clear();
    }


    static inline function addTween(tween:Tween) {
        updating.push(tween);
    }


    static inline function addTargetTween(target:{}, tween:Tween) {
        var list = targetToTweenList.get(target);
        if (list == null) {
            list = new List<Tween>();
            targetToTweenList.set(target, list);
        }
        list.add(tween);
    }

    static inline function removeTargetTween(target:{}, tween:Tween) {
        var list = targetToTweenList.get(target);
        if (list != null) {
            list.remove(tween);
            if (list.length == 0) {
                targetToTweenList.remove(target);
            }
        }
    }

    static inline function forEachTargetTween(target:{}, f:Tween->Void) {
        var list = targetToTweenList.get(target);
        if (list != null) {
            for (tween in list) {
                if (tween.head == null) {
                    f(tween);
                }
            }
        }
    }

}