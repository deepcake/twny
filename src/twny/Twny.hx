package twny;

@:access(twny)
class Twny {


    static var tweens = new Array<Tween>();


    public static function update(dt:Float) {
        var l = tweens.length;
        var i = 0;
        while (i < l) {
            var t = tweens[i];
            t.update(dt);
            // if (t.completed) {
            //     t.active = false;
            //     tweens.splice(i, 1);
            //     l--;
            // }
            // else {
                i++;
            // }
        }
    }


    static inline function activate(t:Tween) {
        tweens.push(t);
        t.active = true;
    }

}