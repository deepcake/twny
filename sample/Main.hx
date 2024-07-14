package;

import js.Browser;
import js.html.CanvasElement;
import twny.easing.*;
import twny.TwnyTools.*;


typedef Sprite = {
    x:Float, y:Float, sx:Float, sy:Float, img:String
}


class Main {

    public static function main() {
        var canvas:CanvasElement = cast Browser.document.querySelector("#canvas");

        var w, h;

        function resize() {
            w = canvas.width = Browser.window.innerWidth;
            h = canvas.height = Browser.window.innerHeight;
        }

        Browser.window.addEventListener('resize', resize);

        resize();

        var context = canvas.getContext2d();
        context.font = '50px serif';
        context.imageSmoothingEnabled = true;

        var emoji1 = [ '🌲', '🌳' ];
        var emoji2 = [ '🌱', '🌷', '🌾', '🌼', '🌻' ];
        var emoji3 = [ '🐒', '🦌', '🦘' ];

        var sprites:Array<Sprite> = [];

        for (i in 0...200) {
            var index = Std.random(emoji1.length);
            var scale = 1.5 + 0.5 * Math.random();
            sprites.push({
                x: Math.random() * w,
                y: Math.random() * h,
                sx: scale,
                sy: scale,
                img: emoji1[index]
            });
        }

        for (i in 0...500) {
            var index = Std.random(emoji2.length);
            var scale = 0.75 + 0.25 * Math.random();
            sprites.push({
                x: Math.random() * w,
                y: Math.random() * h,
                sx: scale,
                sy: scale,
                img: emoji2[index]
            });
        }

        var jumpers:Array<Sprite> = [
            for (i in 0...100) {
                x: Math.random() * w,
                y: Math.random() * h,
                sx: 1,
                sy: 1,
                img: emoji3[Std.random(emoji3.length)]
            }
        ];

        sprites = sprites.concat(jumpers);

        sprites.sort((s1, s2) -> Std.int(s1.y - s2.y));

        for (s in jumpers) {
            var t = tween(2)
                .then(
                    tween(.25)
                        .to(Quint.easeOut, {
                            s.sx = .75;
                            s.sy = 1.5;
                        })
                )
                .then(
                    tween(1)
                        .to(Linear.easeNone, s.x += 150)
                        .then(
                            tween(.25)
                                .to(Quint.easeOut, {
                                    s.sx = 1;
                                    s.sy = 1;
                                })
                        )
                        .onComplete(() -> {
                            if (s.x > w) {
                                s.x -= w;
                            }
                        })
                )
                .then(
                    tween(.5)
                        .to(Cubic.easeOut, s.y -= 100)
                        .then(
                            tween(.5)
                                .to(Cubic.easeIn, s.y += 100)
                        )
                )
                .start(Math.random() * 1)
                .repeat();
        }

        function update() {
            twny.TwnyTools.update(60 / 1000);
            context.setTransform(1, 0, 0, 1, 0, 0);
            context.clearRect(0, 0, w, h);
            for (s in sprites) {
                context.setTransform(1, 0, 0, 1, 0, 0);
                context.translate(s.x, s.y);
                context.scale(-s.sx, s.sy);
                context.fillText(s.img, 0, 0);
            }
        }

        Browser.window.setInterval(update, 60);
    }

}