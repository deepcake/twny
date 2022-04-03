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

        function unsupported(expr:Expr) {
            var msg = 'Expression `${expr.toString()}` is not allowed! Assignment (like `a.b = c` or `a.b += c`) is required instead!';
#if twny_autocompletion_hack
            // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/7699
            // todo: remove after fix
            msg += ' But due `twny_autocompletion_hack` an errored transition will be created anyway to achive autocompletion! Do not forget to fix it!';
            Context.warning(msg, Context.currentPos());

            var error = 'This is errored transition of expr `${expr.toString()}`!';
            return macro new twny.internal.Transition($easing, 0.0, () -> throw $v{error}, v -> $expr);
#else
            Context.error(msg, Context.currentPos());
            return macro null;
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
                    var getFrom = macro function():Float return $e1;
                    var set = macro function(v:Float) $e1 = v;
                    var tr = switch op {
                        case OpAssign: {
                            macro new twny.internal.TransitionDefault($easing, $getFrom, $e2, $set);
                        }
                        case OpAssignOp(aop): {
                            var to = {
                                expr: EBinop(aop, e1, e2),
                                pos: Context.currentPos()
                            }
                            var getTo = macro function():Float return $to;
                            macro new twny.internal.TransitionRelative($easing, $getFrom, $getTo, $set);
                        }
                        case _: {
                            unsupported(expr);
                        }
                    }
                    transitions.push(tr);
                }
                case _: {
                    unsupported(expr);
                }
            }
        }

        process(properties);

        var ret = transitions.fold((e:Expr, r:Expr) -> macro @:privateAccess $r.addTransition($e), self);

        return ret;
    }

}
#end