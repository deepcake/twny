package twny;

import twny.internal.Transition;

#if macro
import haxe.macro.Expr;
#end

@:access(twny)
class Tween {


    var transitions = new Array<Transition>();

    var head:Tween;
    var next:Array<Tween>;

    var stocked = false;

    var onStartCb:Void->Void;
    var onUpdateCb:Void->Void;
    var onCompleteCb:Void->Void;

    public var duration(default, null):Float;

    public var elapsed(default, null) = 0.0;
    public var running(default, null) = false;

    /**
     * Just pause
     */
    @:isVar public var paused(get, set) = false;
    /**
     * If `true` the whole tween chain will be started from the beginning after completion
     */
    @:isVar public var repeatable(get, set) = false;
    /**
     * If `true` the whole tween chain will be disposed after completion (if `repeatable == false`) or after direct calling `stop`
     */
    @:isVar public var autodispose(get, set) = true;

    /**
     * `true` if current tween is completed (elapsed time == duration)
     */
    public var completed(get, never):Bool;

    /**
     * `true` if the whole tween chain is completed (elapsed time of each tween in chain == duration)
     */
    public var fullyCompleted(get, never):Bool;


    /**
     * @param duration duration of current tween
     * @param once if `true` the whole tween chain will be disposed after completion (if `repeatable == false`) or after direct calling `stop`
     */
    public function new(duration:Float, once:Bool = true) {
        this.duration = duration;
        this.autodispose = once;
    }

    /**
     * Makes tween chain reusable (`autodispose = false`)
     */
    public function reuse() {
        autodispose = false;
        return this;
    }

    /**
     * Makes tween chain repeatable (whole tween chain will be started from the beginning after completion)
     */
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

            if (onUpdateCb != null) {
                onUpdateCb();
            }

            if (elapsed >= duration) {
                var offset = elapsed - duration;

                elapsed = duration;
                running = false;

                if (onCompleteCb != null) {
                    onCompleteCb();
                }

                if (next != null) {
                    for (n in next) {
                        n.setup();
                        n.update(offset);
                    }
                }
                else {
                    if (head != null) {
                        if (head.fullyCompleted) {
                            if (repeatable) {
                                head.setup();
                                head.update(offset);
                            }
                            else if (autodispose) {
                                head.dispose();
                            }
                        }
                    }
                    else {
                        if (repeatable) {
                            this.setup();
                            this.update(offset);
                        }
                        else if (autodispose) {
                            this.dispose();
                        }
                    }
                }
            }
        }
    }


    public function start() {
        if (head != null) {
            head.rootStart();
        }
        else {
            this.rootStart();
        }
        return this;
    }

    inline function rootStart() {
        setup();
    }

    /**
     * @param complete if `true` will update each transition of each nested tween to the end
     */
    public function stop(complete = false) {
        if (head != null) {
            head.rootStop(complete);
        }
        else {
            this.rootStop(complete);
        }
        if (autodispose) {
            dispose();
        }
        return this;
    }

    function rootStop(complete:Bool) {
        if (complete && !completed) {
            for (t in transitions) {
                t.apply(1.0);
            }
            if (next != null) {
                for (n in next) {
                    n.setup();
                }
            }
        }
        elapsed = duration;
        running = false;
        if (next != null) {
            for (n in next) {
                n.rootStop(complete);
            }
        }
    }


    public function dispose() {
        if (head != null) {
            head.rootDispose();
        }
        else {
            this.rootDispose();
        }
    }

    function rootDispose() {
        if (next != null) {
            for (n in next) {
                n.rootDispose();
            }
        }
        for (t in transitions) {
            t.dispose();
        }
        transitions.resize(0);
        head = null;
        next = null;
        onStartCb = null;
        onUpdateCb = null;
        onCompleteCb = null;
        elapsed = 0.0;
        running = false;
    }

    /**
     * Pauses the whole tween chain with ability of resuming
     */
    public function pause() {
        paused = true;
        return this;
    }

    /**
     * Resumes the whole tween chain after it has been paused
     */
    public function resume() {
        paused = false;
        return this;
    }

    /**
     * Adds a callback that will be called every time _this_ tween is started (multiple times if `repeatable == true`)
     * @param cb `Void->Void`
     */
    public function onStart(cb:Void->Void) {
        onStartCb = cb;
        return this;
    }

    /**
     * Adds a callback that will be called every time _this_ tween is updated
     * @param cb `Void->Void`
     */
    public function onUpdate(cb:Void->Void) {
        onUpdateCb = cb;
        return this;
    }

    /**
     * Adds a callback that will be called every time _this_ tween is completed (multiple times if `repeatable == true`)
     * @param cb `Void->Void`
     */
    public function onComplete(cb:Void->Void) {
        onCompleteCb = cb;
        return this;
    }

    /**
     * Adds a nested tween that will be started when _this_ tween ends
     * @param tween `Tween`
     */
    public function then(tween:Tween) {
        if (tween.head != null) {
            if (tween.head.next != null) {
                tween.head.next.remove(tween);
            }
        }

        tween.setHead(head != null ? head : this);

        if (next == null) {
            next = new Array<Tween>();
        }
        next.push(tween);
        return this;
    }

    function setHead(tween:Tween) {
        head = tween;
        elapsed = 0.0;
        running = false;
        if (next != null) {
            for (n in next) {
                n.setHead(head);
            }
        }
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
     * @param easing `Float->Float`
     * @param properties function or just block with expressions  
     */
    #if twny_autocompletion_hack // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
    public macro function to(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var single = easingAndProperties.length == 1;
        var easing = single ? macro hxease.Linear.easeNone : easingAndProperties[0];
        var properties = single ? easingAndProperties[0] : easingAndProperties[1];
        return twny.internal.macro.Builder.transitions(self, easing, properties);
    }
    #else
    public macro function to(self:ExprOf<Tween>, easing:ExprOf<Float->Float>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
        return twny.internal.macro.Builder.transitions(self, easing, properties);
    }
    #end


    @:noCompletion
    public function transition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }


    function setup() {
        stock();
        elapsed = 0.0;
        running = true;
        for (t in transitions) {
            t.setup();
        }
        if (onStartCb != null) {
            onStartCb();
        }
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


    function get_paused() {
        return head != null ? head.paused : paused;
    }
    function set_paused(value) {
        return head != null ? head.paused = value : this.paused = value;
    }

    function get_repeatable() {
        return head != null ? head.repeatable : repeatable;
    }
    function set_repeatable(value) {
        return head != null ? head.repeatable = value : this.repeatable = value;
    }

    function get_autodispose() {
        return head != null ? head.autodispose : autodispose;
    }
    function set_autodispose(value) {
        return head != null ? head.autodispose = value : this.autodispose = value;
    }

    inline function get_completed() {
        return elapsed >= duration;
    }

    function get_fullyCompleted() {
        var ret = completed;
        if (next != null) {
            for (n in next) {
                ret = ret && n.fullyCompleted;
            }
        }
        return ret;
    }

}