# twny

![build status](https://github.com/deepcake/twny/actions/workflows/build.yml/badge.svg)

Experimantal macro-based tweening library.
Inspired mostly by [Slide](https://github.com/AndreiRudenko/slide) and [Ceramic Engine](https://github.com/ceramic-engine/ceramic)'s integrated tweening system.

### Wip

### Example
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
      .to(Quad.easeOut, obj.z = 1)
      .then(
        obj.tween(1.0)
          .to(Quad.easeOut, obj.z = 2)
      )
      .repeat()
      .start();

    Twny.update(1.0); // 1st complete
    trace(obj); // { x: 100.0, y: 100.0, z: 1 }

    Twny.update(1.0); // 2nd complete
    trace(obj); // { x: 100.0, y: 100.0, z: 2 }

    Twny.update(2.0);
    trace(obj); // { x: 100.0, y: 200.0, z: 2 }
  }
}
```

### Also
`-D twny_autocompletion_hack` - ugly hack to achive autocompletion for macro func args. See issues:
https://github.com/HaxeFoundation/haxe/issues/7699  
https://github.com/HaxeFoundation/haxe/issues/9421  
