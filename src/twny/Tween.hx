package twny;

import haxe.macro.Printer;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using Lambda;

class Tween {


    var transitions = new Array<Transition>();

    var head:Tween;
    var next:Tween;


    var duration:Float;

    var elapsed(default, null) = 0.0;
    var running(default, null) = false;

    var repeating = false;


    var initialized = false;


    public function new(duration:Float, immediate = true, repeating = false) {
        this.duration = duration;
        this.repeating = repeating;
        if (immediate) {
            start();
        }
    }


    public function update(dt:Float) {
        if (running) {

            if (!initialized) {
                for (t in transitions) {
                    t.reset();
                }
                initialized = true;
            }

            elapsed += dt;

            var k = elapsed < duration ? elapsed / duration : 1.0;

            for (t in transitions) {
                t.apply(k);
            }

            if (elapsed >= duration) {
                running = false;
                if (next != null) {
                    next.startFrom(elapsed - duration);
                }
                else {
                    if (repeating) {
                        if (head != null) {
                            head.startFrom(elapsed - duration);
                        }
                        else {
                            this.startFrom(elapsed - duration);
                        }
                    }
                }
            }
        }
    }


    public function start() {
        running = true;
        elapsed = 0.0;
        initialized = false;
    }

    public function stop() {
        running = false;
        elapsed = 0.0;
        initialized = false;
        if (next != null) {
            next.stop();
        }
    }


    function startFrom(t:Float) {
        start();
        update(t);
    }


    public function then(tween:Tween):Tween {
        tween.head = this;
        this.next = tween;
        tween.repeating = this.repeating;
        tween.stop();
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