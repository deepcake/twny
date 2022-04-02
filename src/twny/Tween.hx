package twny;

#if macro
import haxe.macro.Expr;
#end

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
    var disposeOnComplete = false;

    var stocked = false;
    var disposed = false;


    var completed(get, null):Bool;


    public function new(duration:Float, repeat = false) {
        this.duration = duration;
        this.repeat = repeat;
    }

    public function once() {
        disposeOnComplete = true;
        return this;
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
                        if (disposeOnComplete) {
                            if (head != null) {
                                head.dispose();
                            }
                            else {
                                this.dispose();
                            }
                        }
                    }
                }
            }
        }
    }


    public function start() {
        stock();
        setup();
        return this;
    }

    function setup() {
        elapsed = 0.0;
        running = true;
        for (t in transitions) {
            t.reset();
        }
    }

    function stock() {
        if (!stocked) {
            Twny.addTween(this);
            stocked = true;
        }
        if (next != null) {
            next.stock();
        }
    }


    public function then(tween:Tween) {
        tween.setHead(head != null ? head : this);
        if (stocked) {
            stock();
        }
        this.next = tween;
        return this;
    }

    function setHead(tween:Tween) {
        this.head = tween;
        running = false;
        repeat = head.repeat;
        disposeOnComplete = head.disposeOnComplete;
        if (next != null) {
            next.setHead(head);
        }
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
        if (disposeOnComplete) {
            dispose();
        }
        return this;
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


    function dispose() {
        transitions.resize(0);
        head = null;
        next = null;
        elapsed = 0.0;
        running = false;
        disposed = true;
    }


    /**
     * Properties can be passed in any format below:  
     * `() -> { obj.x = 5; obj.y = 10; }`  
     * `() -> obj.x = 5`  
     * `{ obj.x = 5; obj.y = 10; }`  
     * or just `obj.x = 5`  
     * For example, `obj.x = 5` will become a transition with `from = obj.x` and `to = 5`.  
     * Transition will be generated for every assigment in the block.  
     * It is also possible to make a relative transition: `obj.y += 5`  
     * So on every start a `to` var will be initialized as `obj.y + 5` instead of simple `5`. Should be useful for reuse.
     * @param easing hxease.IEasing
     * @param properties function or just block with expressions  
     * 
     */
#if twny_autocompletion_hack
    // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
    // todo: remove after fix
    public macro function to(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var singleArg = easingAndProperties.length == 1;
        var easing = singleArg ? macro hxease.Linear.easeNone : easingAndProperties[0];
        var properties = singleArg ? easingAndProperties[0] : easingAndProperties[1];
#else
    public macro function to(self:ExprOf<Tween>, easing:ExprOf<hxease.IEasing>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
#end
        return twny.macro.Tween.transitions(self, easing, properties);
    }


    @:noCompletion public function addTransition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }


    function get_completed() {
        return elapsed >= duration && (next != null ? next.completed : true);
    }

}