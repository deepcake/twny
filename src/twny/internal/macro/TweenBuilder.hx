package twny.internal.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using Lambda;

class TweenBuilder {


    public static function transitions(self:ExprOf<Tween>, easing:ExprOf<hxease.IEasing>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
        var transitions = [];

        function fail(expr:Expr) {
            var msg = 'Expression `${expr.toString()}` is not allowed! Assignment (like `a.b = c` or `a.b += c`) is required instead!';

            // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/7699
            #if twny_autocompletion_hack
            msg += ' But due `twny_autocompletion_hack` an errored transition will be created anyway to achive autocompletion! Do not forget to fix it!';
            Context.warning(msg, expr.pos);

            var error = 'This is errored transition of expr `${expr.toString()}`!';
            var tr = macro new twny.internal.DefaultTransition($easing, () -> throw $v{error}, 0.0, v -> $expr);
            transitions.push(tr);
            #else
            Context.error(msg, expr.pos);
            #end
        }

        function process(expr:Expr) {
            switch expr.expr {
                case EFunction(_, { expr: e }) | EReturn(e) | EMeta(_, e): {
                    process(e);
                }
                case EBlock(exprs): {
                    exprs.iter(process);
                }
                case EBinop(op, e1, e2): {
                    var getFr = macro function():Float return $e1;
                    var set = macro function(v:Float) $e1 = v;
                    switch op {
                        case OpAssign: {
                            var tr = macro new twny.internal.DefaultTransition($easing, $getFr, $e2, $set);
                            transitions.push(tr);
                        }
                        case OpAssignOp(aop): {
                            var to = {
                                expr: EBinop(aop, e1, e2),
                                pos: expr.pos
                            }
                            var getTo = macro function():Float return $to;
                            var tr = macro new twny.internal.RelativeTransition($easing, $getFr, $getTo, $set);
                            transitions.push(tr);
                        }
                        case _: {
                            fail(expr);
                        }
                    }
                }
                case _: {
                    fail(expr);
                }
            }
        }

        process(properties);

        var ret = transitions.fold((e:Expr, r:Expr) -> macro $r.addTransition($e), self);

        return macro @:privateAccess $ret;
    }

}
#end