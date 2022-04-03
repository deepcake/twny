package twny;

@:access(twny)
class Twny {


    static var tweens = new Array<Tween>();


    public static function update(dt:Float) {
        var l = tweens.length;
        var i = 0;
        while (i < l) {
            var tween = tweens[i];
            tween.update(dt);
            if (!tween.running) {
                tweens.splice(i, 1);
                tween.stocked = false;
                l--;
            }
            else {
                i++;
            }
        }
    }

    public static function reset() {
        for (tween in tweens) {
            tween.dispose();
        }
        tweens.resize(0);
    }


    static inline function addTween(tween:Tween) {
        tweens.push(tween);
    }

}