package twny;

import twny.internal.Transition;

#if macro
import haxe.macro.Expr;
#end

@:access(twny)
class Tween {


    var transitions = new Array<Transition>();

    var head(default, set):Tween;
    var next:Tween;

    var stocked = false;

    public var duration(default, null):Float;

    public var elapsed(default, null) = 0.0;
    public var running(default, null) = false;

    public var paused(get, null) = false;
    public var repeatable(get, null) = false;
    public var disposable(get, null) = false;

    var completed(get, null):Bool;


    public function new(duration:Float) {
        this.duration = duration;
    }

    public function once() {
        disposable = true;
        return this;
    }

    public function repeat() {
        repeatable = true;
        return this;
    }

    public function update(dt:Float) {
        if (dt > 0 && running && !paused) {

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
                    if (head != null) {
                        if (repeatable) {
                            head.setup();
                            head.update(offset);
                        }
                        else if (disposable) {
                            head.dispose();
                        }
                    }
                    else {
                        if (repeatable) {
                            this.setup();
                            this.update(offset);
                        }
                        else if (disposable) {
                            this.dispose();
                        }
                    }
                }
            }
        }
    }


    public function start() {
        setup();
        return this;
    }

    function setup() {
        elapsed = 0.0;
        running = true;
        for (t in transitions) {
            t.reset();
        }
        stock();
    }

    function stock() {
        if (!stocked) {
            Twny.addTween(this);
            stocked = true;
        }
    }

    function unstock() {
        stocked = false;
    }


    public function then(tween:Tween) {
        tween.set_head(head != null ? head : this);
        this.next = tween;
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
        if (disposable) {
            dispose();
        }
        return this;
    }


    public function pause() {
        paused = true;
        return this;
    }

    public function resume() {
        paused = false;
        return this;
    }


    public function dispose() {
        if (next != null) {
            next.dispose();
        }
        transitions.resize(0);
        head = null;
        next = null;
        elapsed = 0.0;
        running = false;
    }


    /**
     * Properties can be passed in any format below:  
     * `() -> { obj.x = 5; obj.y = 10; }`  
     * `() -> obj.x = 5`  
     * `{ obj.x = 5; obj.y = 10; }`  
     * `obj.x = 5`  
     * Own transition will be generated for every assigment in the properties block. 
     * For example, `obj.x = 5` will become a transition with var `from = obj.x` and var `to = 5`.  
     * It is also possible to make a relative transition by passing a short assingment `obj.y += 5`. 
     * So on every start var `to` will be initialized as `obj.y + 5` instead of simple `5`. It can be useful for reuse.
     * @param easing hxease.IEasing
     * @param properties function or just block with expressions  
     */
#if twny_autocompletion_hack
    // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
    // todo: remove after fix
    public macro function to(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var single = easingAndProperties.length == 1;
        var easing = single ? macro hxease.Linear.easeNone : easingAndProperties[0];
        var properties = single ? easingAndProperties[0] : easingAndProperties[1];
#else
    public macro function to(self:ExprOf<Tween>, easing:ExprOf<hxease.IEasing>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
#end
        return twny.internal.macro.TweenBuilder.transitions(self, easing, properties);
    }


    function addTransition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }


    function set_head(tween:Tween) {
        head = tween;
        running = false;
        if (next != null) {
            next.set_head(head);
        }
        return head;
    }

    function get_paused() {
        return head != null ? head.paused : paused;
    }

    function get_repeatable() {
        return head != null ? head.repeatable : repeatable;
    }

    function get_disposable() {
        return head != null ? head.disposable : disposable;
    }

    function get_completed() {
        return elapsed >= duration && (next != null ? next.completed : true);
    }

}