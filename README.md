# twny

![build status](https://github.com/deepcake/twny/actions/workflows/build.yml/badge.svg)

Experimental macro-based tweening library.
Inspired mostly by [Slide](https://github.com/AndreiRudenko/slide) and [Ceramic Engine](https://github.com/ceramic-engine/ceramic)'s integrated tweening system.

### Wip

### How It Looks Like
```haxe
import twny.Twny.tween;

class Example {
  static function main() {
    var s = { x: 0., y: 0., z: 0., scale: 1. };

    tween(0)
      .then(
        tween(1.0)
          .to(Linear.easeNone, {
            s.x = 200;
            s.z = 200;
          })
          .from(Quad.easeOut, {
            s.scale *= 2;
          })
          .onComplete(() -> {
            trace("Done!");
          })
      )
      .then(
        tween(0.5)
          .to(Circ.easeOut, s.y -= 100)
          .then(
            tween(0.5)
              .to(Circ.easeIn, s.y += 100)
          )
      )
      .start()
      .repeat();

    Twny.update(.5);
  }
}
```

### Features Achieved
 - Access to nested fields at any depth! _(also see [also](#also) about autocompletion)_
 ```haxe
  tween(1.0)
    .to(Quad.easeIn, {
      spr.pos.x = 100;
      spr.pos.y = 150;
      scene.getChildAt(1).pos.x = -50; // any getter/setter expressions are acceptable
    })
 ```
- Tween chaining and branching!
 ```haxe
  tween(0) // just combine a few other tweens (can also be used for delay)
    .then(
      tween(1.0).to(...) // will be started after 1-st tween
    )
    .then(
      tween(3.0).to(...) // will be started after 1-st tween in parallel with tween above
        .then(...)
        .then(...)
    )
 ```
 - Repeating the whole tween tree without using _oncomplete_ callback!
 ```haxe
  tween(.5).to(Quad.easeIn, spr.x = 100)
    .then(
      tween(.5).to(Quad.easeIn, spr.x = 200)
    )
    .repeat()
    .start();
  Twny.update(.5); // spr.x == 100
  Twny.update(.5); // spr.x == 200
  Twny.update(.5); // spr.x == 100
  Twny.update(.5); // spr.x == 200
 ```
  - Parallel transitions with different easings! _(not a big deal, but this is the one that made me start working on this lib)_
 ```haxe
  tween(1.0)
    .to(Quad.easeIn, spr.x = 100)
    .to(Circ.easeOut, spr.y = 50)
 ```
 - Time callbacks and playback control!
 ```haxe
  var t = tween(1.0)
    //.onStart()
    .on(.5, () -> trace('Half!'))
    .onComplete(() -> trace('The end!'));

  t.start();
  t.pause();
  t.resume();
```
 - Macro-based, no reflection _(but a several macro-generated anonymous functions instead)_

### Also
`-D twny-autocompletion-hack` - workaround to achieve autocompletion for macro func args. See issues:
https://github.com/HaxeFoundation/haxe/issues/7699
https://github.com/HaxeFoundation/haxe/issues/9421
