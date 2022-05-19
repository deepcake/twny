# twny

![build status](https://github.com/deepcake/twny/actions/workflows/build.yml/badge.svg)

Experimantal macro-based tweening library.
Inspired mostly by [Slide](https://github.com/AndreiRudenko/slide) and [Ceramic Engine](https://github.com/ceramic-engine/ceramic)'s integrated tweening system.

### Wip

### Features Achieved
 - Access to nested fields at any depth! _(also see [**Also**](#also) about autocompletion)_
 ```haxe
  tween(1.0)
    .to(Quad.easeIn, {
      spr.pos.x = 100;
      spr.pos.y = 150;
      spr.getChildAt(1).pos.x = -50; // any expressions providing getting and setting are acceptable
    })
 ```
- Tween chaining and branching!  
 ```haxe
  tween(0) // empty tween just to combine a few other tweens, also can be used for waiting
    .then(
      tween(1.0).to(...) // will be started in parallel with 'then' tween below
    )
    .then(
      tween(3.0).to(...)
        .then(...)
        .then(...)
    )
 ```
 - Parallel transitions with different easings!  
 ```haxe
  tween(1.0)
    .to(Quad.easeIn, spr.x = 100)
    .to(Quad.easeOut, spr.y = 50)
    .start();
  Twny.update(1.0); // spr.x == 100, spr.y = 50
 ```
 - Repeating the whole tween tree without _oncomplete_ callback hack!  
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
 - Some callbacks and playback control!  
 ```haxe
  var t = tween(1.0).to(...)
    //.onStart()
    //.onUpdate()
    .onComplete(() -> trace('Hey You!'));
  t.start();
  t.pause();
  t.resume();
  t.stop();
  // target tween with `using twny.Twny`
  spr.tween(1.0).to(...);
  spr.start();
  spr.stop();
 ```
 - Macro-based, no reflection _(but a lot of macro-generated functions instead)_  

### How It Looks Like
```haxe
using twny.Twny;

class Example {
  static function main() {
    var obj = { x: 0.0, y: 0.0, z: 0.0 };

    var t = obj.tween(1.0)
      .to(Quad.easeIn, {
        obj.x = 100;
        obj.y += 100; // relative transition
      })
      .to(Circ.easeIn, obj.z = 1)
      .then(
        obj.tween(1.0).to(Circ.easeOut, obj.z = 2)
      )
      .repeat()
      .start();

    Twny.update(1.0); // { x: 100, y: 100, z: 1 }
    Twny.update(1.0); // { x: 100, y: 100, z: 2 }
    Twny.update(1.0); // { x: 100, y: 200, z: 1 }
  }
}
```

### Also
`-D twny_autocompletion_hack` - ugly hack to achive autocompletion for macro func args. See issues:  
https://github.com/HaxeFoundation/haxe/issues/7699  
https://github.com/HaxeFoundation/haxe/issues/9421  
