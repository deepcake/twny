package twny;

import haxe.macro.Printer;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using Lambda;

@:access(twny)
class Tween {


    var transitions = new Array<Transition>();

    var head:Tween;
    var next:Tween;

    var duration:Float;

    var elapsed = 0.0;
    var running = false;


    var paused = false;

    var repeat = false;

    var active = false;


    public function new(duration:Float, repeat = false) {
        this.duration = duration;
        this.repeat = repeat;
    }

    public function update(dt:Float) {
        if (running && !paused) {

            elapsed += dt;

            var k = elapsed < duration ? elapsed / duration : 1.0;

            for (t in transitions) {
                t.apply(k);
            }

            if (elapsed >= duration) {
                var offset = elapsed - duration;

                elapsed = duration;
                running = false;

                if (next != null) {
                    next.setup();
                    next.update(offset);
                }
                else {
                    if (repeat) {
                        if (head != null) {
                            head.setup();
                            head.update(offset);
                        }
                        else {
                            this.setup();
                            this.update(offset);
                        }
                    }
                    else {
                        // TODO teardown
                    }
                }
            }
        }
    }

    function setup() {
        elapsed = 0.0;
        running = true;
        for (t in transitions) {
            t.reset();
        }
        if (!active) {
            Twny.activate(this);
        }
    }

    public function start() {
        setup();
        return this;
    }

    public function stop(complete = false) {
        if (complete && elapsed < duration) {
            for (t in transitions) {
                t.apply(1.0);
            }
            if (next != null) {
                next.setup();
            }
        }

        elapsed = duration;
        running = false;

        if (next != null) {
            next.stop(complete);
        }
        return this;
    }


    public function dispose() {
        transitions.resize(0);
        head = null;
        next = null;
    }


    public function pause() {
        paused = true;
        if (next != null) {
            next.pause();
        }
    }

    public function resume() {
        paused = false;
        if (next != null) {
            next.resume();
        }
    }


    function addNextTween(tween:Tween) {
        this.next = tween;
        tween.head = this;
        tween.repeat = this.repeat;
        tween.stop();
    }


    public function then(tween:Tween):Tween {
        this.addNextTween(tween);
        return this;
    }




#if twny_autocompletion_hack
    // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
    // todo: remove after fix
    macro public function transite(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var singleArg = easingAndProperties.length == 1;
        var easing = singleArg ? macro hxease.Linear.easeNone : easingAndProperties[0];
        var properties = singleArg ? easingAndProperties[0] : easingAndProperties[1];
#else
    macro public function transite(self:ExprOf<Tween>, easing:ExprOf<hxease.IEasing>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
#end
        var transitions = [];

        function process(expr:Expr) {
            switch expr.expr {
                case EFunction(_, { expr: e }) | EReturn(e) | EMeta(_, e): {
                    process(e);
                }
                case EBlock(exprs): {
                    exprs.iter(process);
                }
                case EBinop(OpAssign, e1, e2): {
                    var gtExpr = macro function() return $e1;
                    var stExpr = macro function(value:Float) $e1 = value;
                    var tr = macro new twny.Transition($easing, $e2, $gtExpr, $stExpr);
                    transitions.push(tr);
                }
                case e: {
                    var msg = 'Expr `${expr.toString()}` is not allowed! Assignment (like `a.b = c`) is required instead!';
#if twny_autocompletion_hack
                    // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/7699
                    // todo: remove after fix
                    msg += ' But due `twny_autocompletion_hack` an errored transition will be created anyway to achive autocompletion! Beware!';
                    Context.warning(msg, Context.currentPos());

                    var error = 'This is errored transition of expr `${expr.toString()}`!';
                    var tr = macro new twny.Transition($easing, 0.0, () -> throw $v{error}, v -> $expr);
                    transitions.push(tr);
#else
                    Context.error(msg, Context.currentPos());
#end
                }
            }
        }

        process(properties);

        var ret = transitions.fold((e:Expr, r:Expr) -> macro $r.addTransition($e), self);

        return ret;
    }


    @:noCompletion public function addTransition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }

}