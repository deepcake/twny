package twny;

import haxe.ds.ObjectMap;

@:access(twny)
class Twny {

    static var targets = new ObjectMap<Dynamic, Array<Tween>>();
    static var running = new Array<Tween>();


    public static function tween<T:Dynamic>(target:T, duration:Float) {
        return new TargetTween(target, duration);
    }

    public static function stop<T:Dynamic>(target:T, complete = false) {
        var targetTweens = targets.get(target);
        if (targetTweens != null) {
            for (tween in targetTweens) {
                tween.stop(complete);
            }
        }
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
    }


    static inline function addTween(tween:Tween) {
        running.push(tween);
    }

    static inline function addTargetTween(target:Dynamic, tween:Tween) {
        var targetTweens = targets.get(target);
        if (targetTweens == null) {
            targetTweens = new Array<Tween>();
            targets.set(target, targetTweens);
        }
        targetTweens.push(tween);
    }

    static inline function removeTargetTween(target:Dynamic, tween:Tween) {
        var targetTweens = targets.get(target);
        if (targetTweens != null) {
            targetTweens.remove(tween);
            if (targetTweens.length == 0) {
                targets.remove(target);
            }
        }
    }

}