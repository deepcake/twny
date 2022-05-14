package twny.internal.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using Lambda;

class Builder {


    public static function transitions(self:ExprOf<Tween>, easing:ExprOf<Float->Float>, properties:ExprOf<Void->Void>, swapFromTo = false):ExprOf<Tween> {
        var transitions = [];

        function fail(expr:Expr) {
            var msg = 'Expression `${expr.toString()}` is not allowed! Assignment (like `a.b = c` or `a.b += c`) is required instead!';
#if twny_autocompletion_hack // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/7699
            msg += ' But due `twny_autocompletion_hack` an errored transition will be created anyway to achive autocompletion! Do not forget to fix it!';
            Context.warning(msg, expr.pos);
            var error = 'This is errored transition of expr `${expr.toString()}`!';
            return macro new twny.internal.Transition($easing, () -> throw $v{error}, 0.0, v -> $expr);
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
                    var gfr = macro function() return $e1;
                    var gto = switch op {
                        // a = x
                        case OpAssign: {
                            macro function() return $e2;
                        }
                        // a += x, a -= x, a *= x
                        case OpAssignOp(aop): {
                            var to = {
                                expr: EBinop(aop, e1, e2),
                                pos: expr.pos
                            }
                            macro function() return $to;
                        }
                        case _: {
                            fail(expr);
                        }
                    }
                    var tr = swapFromTo ?
                        macro new twny.internal.Transition($easing, $gto, $gfr, $set) :
                        macro new twny.internal.Transition($easing, $gfr, $gto, $set);

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