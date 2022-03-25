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
                x: 0.0, 
                n: { 
                    x: 0.0 
                } 
            } 
        };

        var t = new Tween(10.0, true, true)
            .transite(Linear.easeNone, () -> {
                obj.x = 100;
                obj.y = 150;
            })
            .then(
                new Tween(10.0)
                    .transite(Linear.easeNone, obj.x = 20)
                    .transite(Linear.easeNone, () -> obj.y = 0)
                    .transite(Linear.easeNone, { obj.z = 0; })
                    .transite(Linear.easeNone, { 
                        obj.n.x = 1.0;
                        obj.n.n.x = obj.z;
                    })
                    
            );


        trace(obj);


        t.update(1.0);


        trace(obj);


        t.update(14.0);


        trace(obj);


        t.update(20.0);


        trace(obj);

    }
}
