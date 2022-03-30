import twny.Twny;
import hxease.Cubic;
import hxease.Quad;
import hxease.Linear;
import twny.Tween;

class Main {
    static function main() {
        trace("Hello, world!");

        var obj = { 
            x: .0, 
            y: .0, 
            z: 100.0,
            n: { 
                a: 0.0, 
                n: { 
                    b: 0.0 
                } 
            } 
        };

        var t = new Tween(10.0, true)
            .transite(Linear.easeNone, () -> {
                obj.x = 100;
                obj.y = 150;
                obj.z = 0;
            })
            .then(
                new Tween(10.0)
                    .transite(Linear.easeNone, obj.x = 50)
                    .transite(Linear.easeNone, () -> obj.y = 300)
                    .transite(Linear.easeNone, { obj.z = 10000; })
                    .transite(Linear.easeNone, { 
                        obj.n.a = 1.0;
                        obj.n.n.b = obj.z;
                    })
                    
            )
            .start();


        trace(obj);


        Twny.update(1.0);


        trace(obj);


        Twny.update(14.0);


        trace(obj);


        Twny.update(20.0);


        trace(obj);


        t.pause();
        Twny.update(1.0);
        trace('pause  ' + obj);

        t.resume();
        Twny.update(1.0);
        trace('resume ' + obj);

        t.stop(true);
        Twny.update(1.0);
        trace('stop   ' + obj);

        t.start();
        Twny.update(1.0);
        trace('start  ' + obj);

    }
}
