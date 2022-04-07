# twny

![build status](https://github.com/deepcake/twny/actions/workflows/build.yml/badge.svg)

Experimantal macro-based tweening library.
Inspired mostly by [Slide](https://github.com/AndreiRudenko/slide) and [Ceramic Engine](https://github.com/ceramic-engine/ceramic)'s integrated tweening system.

### Wip

### Features Achieved
 - Multiple tween chaining!
 - Repeating whole tween chain without oncomplete callback hack!
 - Parallel transitions with different easing!
 - Access to nested variabels at any depth!
 - Macro-based, no reflection (but a lot of macro-generated functions instead)
 - Some callbacks and playback control!

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
        obj.tween(1.0).to(Quad.easeOut, obj.z = 2)
      )
      .then(
        // will run in parallel with 'then' tween above
        obj.tween(1.0).to(Quad.easeOut, ...)
      )
      .repeat()
      .start();

    Twny.update(1.0); // 1st completed
    trace(obj); // { x: 100, y: 100, z: 1 }

    Twny.update(1.0); // 2nd completed
    trace(obj); // { x: 100, y: 100, z: 2 }

    Twny.update(2.0); // both completed again
    trace(obj); // { x: 100, y: 200, z: 2 }
  }
}
```

### Also
`-D twny_autocompletion_hack` - ugly hack to achive autocompletion for macro func args. See issues:
https://github.com/HaxeFoundation/haxe/issues/7699  
https://github.com/HaxeFoundation/haxe/issues/9421  
