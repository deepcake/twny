package twny.internal.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using Lambda;

class Builder {

    public static function transitions(self:ExprOf<Tween>, easing:ExprOf<Float->Float>, properties:ExprOf<Void->Void>, swapToFrom = false):ExprOf<Tween> {
        var transitions = [];

        function fail(expr:Expr) {
            var msg = 'Expression `${expr.toString()}` is not allowed! Assignment (like `a.b = c` or `a.b += c`) is required instead!';
#if twny_autocompletion_hack // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/7699
            msg += ' But due `twny_autocompletion_hack` an errored transition will be created anyway to achive autocompletion! Do not forget to fix it!';
            Context.warning(msg, expr.pos);
            var error = 'This is errored transition of expr `${expr.toString()}`!';
            return macro new twny.internal.FixedToTransition($easing, () -> throw $v{error}, 0.0, v -> $expr);
#else
            Context.error(msg, expr.pos);
            return null;
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
                    var set = macro function(v) $e1 = v;
                    var getf = macro function() return $e1;
                    var tr = switch op {
                        // a = x
                        case OpAssign: {
                            swapToFrom ?
                                macro new twny.internal.FixedFromTransition($easing, $e2, $getf, $set) :
                                macro new twny.internal.FixedToTransition($easing, $getf, $e2, $set);
                        }
                        // a += x, a -= x, a *= x
                        case OpAssignOp(aop): {
                            var to = {
                                expr: EBinop(aop, e1, e2),
                                pos: expr.pos
                            }
                            var gett = macro function() return $to;
                            swapToFrom ?
                                macro new twny.internal.RelativeTransition($easing, $gett, $getf, $set) :
                                macro new twny.internal.RelativeTransition($easing, $getf, $gett, $set);
                        }
                        // a == x
                        case OpEq: {
                            swapToFrom ?
                                macro new twny.internal.FixedTransition($easing, $e2, $e1, $set) :
                                macro new twny.internal.FixedTransition($easing, $e1, $e2, $set);
                        }
                        case _: {
                            fail(expr);
                        }
                    }
                    transitions.push(tr);
                }
                case _: {
                    var tr = fail(expr);
                    transitions.push(tr);
                }
            }
        }

        process(properties);

        var ret = transitions.fold((e:Expr, r:Expr) -> macro $r.transition($e), self);

        return ret;
    }

}
#end