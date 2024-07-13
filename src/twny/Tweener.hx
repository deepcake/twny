package twny;

@:access(twny)
class Tweener {

    final updating = new Array<Tween>();


    public function new() {
        
    }

    public function tween(duration:Float, autodispose = true) {
        return new Tween(this, duration, autodispose);
    }

    public function update(dt:Float) {
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

    public function reset() {
        for (tween in updating) {
            if (tween.head != null) {
                tween.head.dispose();
            }
            else {
                tween.dispose();
            }
        }
        updating.resize(0);
    }


    inline function queue(tween:Tween) {
        updating.push(tween);
    }

}