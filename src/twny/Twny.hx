package twny;

import haxe.ds.ObjectMap;
import haxe.ds.List;

using Lambda;

@:access(twny)
class Twny {


    static var targets = new ObjectMap<{}, List<Tween>>();
    static var running = new Array<Tween>();


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
        var l = running.length;
        var i = 0;
        while (i < l) {
            var tween = running[i];
            tween.update(dt);
            if (!tween.running) {
                tween.unstock();
                running.splice(i, 1);
                l--;
            }
            else {
                i++;
            }
        }
    }

    public static function reset() {
        for (tween in running) {
            tween.dispose();
        }
        running.resize(0);

        [ for (tweens in targets) tweens ].iter(tweens -> {
            for (tween in tweens) {
                tween.dispose();
            }
        });

        targets.clear();
    }


    static inline function addTween(tween:Tween) {
        running.push(tween);
    }

    static inline function addTargetTween(target:{}, tween:Tween) {
        var targetTweens = targets.get(target);
        if (targetTweens == null) {
            targetTweens = new List<Tween>();
            targets.set(target, targetTweens);
        }
        if (!targetTweens.has(tween)) {
            targetTweens.add(tween);
        }
    }

    static inline function removeTargetTween(target:{}, tween:Tween) {
        var targetTweens = targets.get(target);
        if (targetTweens != null) {
            targetTweens.remove(tween);
            if (targetTweens.length == 0) {
                targets.remove(target);
            }
        }
    }

    static inline function forEachTargetTween(target:{}, f:Tween->Void) {
        var targetTweens = targets.get(target);
        if (targetTweens != null) {
            for (tween in targetTweens) {
                f(tween);
            }
        }
    }

}