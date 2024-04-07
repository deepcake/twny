package twny;

import twny.internal.Transition;

#if macro
import haxe.macro.Expr;
#end


@:publicFields @:structInit private class Cb {
    var time:Float;
    var fn:Void->Void;
}


@:access(twny)
class Tween {

    public var duration(default, null):Float;

    public var elapsed(default, null) = 0.0;
    public var running(default, null) = false;

    /**
     * Just pause
     */
    @:isVar public var paused(get, set) = false;
    /**
     * If `true` the whole tween tree will be started from the beginning after completion
     */
    @:isVar public var repeatable(get, set) = false;
    /**
     * If `true` the whole tween tree will be disposed after completion (if `repeatable == false`) or after direct calling `stop()`
     */
    @:isVar public var autodispose(get, set) = true;

    /**
     * `true` if  _this_ tween is completed (elapsed time == duration)
     */
    public var completed(get, never):Bool;

    /**
     * `true` if the whole tween tree is completed (elapsed time of each tween == duration)
     */
    public var fullyCompleted(get, never):Bool;


    var transitions = new Array<Transition>();

    var head:Tween;
    var next:Array<Tween>;

    var stocked = false;

    var cbs:Array<Cb>;
    var cbi = 0;


    /**
     * @param duration duration of current tween
     * @param autodispose if `true` the whole tween tree will be disposed after completion (if `repeatable == false`) or after direct calling `stop`
     */
    public function new(duration:Float, autodispose = true) {
        this.duration = duration;
        this.autodispose = autodispose;
    }

    /**
     * Makes tween reusable (`autodispose = false`)
     */
    public function reuse() {
        autodispose = false;
        return this;
    }

    /**
     * Makes tween repeatable (the whole tween tree will be started from the beginning after completion)
     */
    public function repeat() {
        repeatable = true;
        return this;
    }

    public function update(dt:Float) {
        if (dt >= 0 && running && !paused) {

            elapsed += dt;

            var k = elapsed < duration ? elapsed / duration : 1.0;

            for (t in transitions) {
                t.apply(k);
            }

            emit();

            if (elapsed >= duration) {
                var offset = elapsed - duration;

                elapsed = duration;
                running = false;

                if (next != null) {
                    for (n in next) {
                        n.setup(offset);
                    }
                }
                else {
                    if (head != null) {
                        if (head.fullyCompleted) {
                            if (repeatable) {
                                head.setup(offset);
                            }
                            else if (autodispose) {
                                head.dispose();
                            }
                        }
                    }
                    else {
                        if (repeatable) {
                            this.setup(offset);
                        }
                        else if (autodispose) {
                            this.dispose();
                        }
                    }
                }
            }
        }
    }

    /**
     * Starts whole tween tree
     */
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
     * Stops whole tween tree (and disposes whole tween tree if tween is autodisposible)
     * @param complete if `true` the each transition of the each nested tween will be updated to the end.  
     * __Note__ that in some cases with multilple parallel nested tweens the forced completed values may differ if they was completed in the regular way. 
     * It is happening because the force completion is completing tweens in the order they was defined, ignoring any differences in duration. 
     * So, to minimize the possible differences, it is preferable to define tweens from a shorter duration to a longer one. 
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
            if (!running) {
                setup();
            }
            if (repeatable) {
                repeatable = false;
                update(duration);
                repeatable = true;
            }
            else {
                update(duration);
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

    /**
     * Disposes whole tween tree. Tween cannot be restarted after calling this method.
     */
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
        cbs = null;
        cbi = 0;
        elapsed = 0.0;
        running = false;
    }

    /**
     * Pauses the whole tween tree with ability of resuming
     */
    public function pause() {
        paused = true;
        return this;
    }

    /**
     * Resumes the whole tween tree after it has been paused
     */
    public function resume() {
        paused = false;
        return this;
    }


    /**
     * Adds a callback that will be called on passed _time_
     */
    public function on(time:Float, cb:Void->Void) {
        if (cbs == null) {
            cbs = [ { time: time, fn: cb } ];
        }
        else {
            cbs.push({ time: time, fn: cb });
            haxe.ds.ArraySort.sort(cbs, (cb1, cb2) -> cb1.time == cb2.time ? 0 : cb1.time > cb2.time ? 1 : -1);
        }
        return this;
    }

    /**
     * Adds a callback that will be called every time _this_ tween is started (multiple times if `repeatable == true`)
     * @param cb `Void->Void`
     */
    public function onStart(cb:Void->Void) {
        return inline on(0., cb);
    }

    /**
     * Adds a callback that will be called every time _this_ tween is completed (multiple times if `repeatable == true`)
     * @param cb `Void->Void`
     */
    public function onComplete(cb:Void->Void) {
        return inline on(duration, cb);
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
     * Creates transitions of passed _properties_ with passed _easing_ from the current value to the assingned value.  
     * There are available some relativity control of the created transitions depending on the assignment type. 
     * Relative transitions are called init on each tween start, whereas fixed transitions are called init only once on creation.  
     * - simple assignment `o.x = val` produces relative `from = o.x` and fixed `to = val`.  
     * - short assingment `o.x += val` produces relative `from = o.x` and relative `to = o.x + val`.  
     * - equality op `o.x == val` produces fixed `from = o.x` and fixed `to = val`.  
     * @param easing `Float->Float` easing function
     * @param properties single assingment expression like `o.x = 5` or a block of expressions `{ o.x = 5; o.y = 10; }`
     */
#if twny_autocompletion_hack
    public macro function to(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var single = easingAndProperties.length == 1;
        var easing = single ? macro twny.easing.Linear.easeNone : easingAndProperties[0];
        var properties = single ? easingAndProperties[0] : easingAndProperties[1];
        return twny.internal.macro.Builder.transitions(self, easing, properties);
    }
#else
    public macro function to(self:ExprOf<Tween>, easing:ExprOf<Float->Float>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
        return twny.internal.macro.Builder.transitions(self, easing, properties);
    }
#end

    /**
     * Creates transitions of passed _properties_ with passed _easing_ from the assingned value to the current value.  
     * There are available some relativity control of the created transitions depending on the assignment type. 
     * Relative transitions are called init on each tween start, whereas fixed transitions are called init only once on creation.  
     * - simple assignment `o.x = val` produces relative `to = o.x` and fixed `from = val`.  
     * - short assingment `o.x += val` produces relative `to = o.x` and relative `from = o.x + val`.  
     * - equality op `o.x == val` produces fixed `to = o.x` and fixed `from = val`.  
     * @param easing `Float->Float` easing function
     * @param properties single assingment expression like `o.x = 5` or block of expressions `{ o.x = 5; o.y = 10; }`
     */
#if twny_autocompletion_hack
    public macro function from(self:ExprOf<Tween>, easingAndProperties:Array<Expr>):ExprOf<Tween> {
        var single = easingAndProperties.length == 1;
        var easing = single ? macro twny.easing.Linear.easeNone : easingAndProperties[0];
        var properties = single ? easingAndProperties[0] : easingAndProperties[1];
        return twny.internal.macro.Builder.transitions(self, easing, properties, true);
    }
#else
    public macro function from(self:ExprOf<Tween>, easing:ExprOf<Float->Float>, properties:ExprOf<Void->Void>):ExprOf<Tween> {
        return twny.internal.macro.Builder.transitions(self, easing, properties, true);
    }
#end

    /**
     * @param easing `Float->Float` easing function
     * @param cb 
     */
    public function fn(easing:Float->Float, from = 0., to = 1., cb:Float->Void):Tween {
        return transition(new twny.internal.FixedTransition(easing, from, to, cb));
    }


    @:noCompletion public function transition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }


    function emit() {
        if (cbs != null) {
            for (i in cbi...cbs.length) {
                if (elapsed >= cbs[i].time) {
                    cbs[i].fn();
                    cbi++;
                }
                else {
                    break;
                }
            }
        }
    }

    function setup(offset = 0.) {
        stock();
        elapsed = 0.0;
        running = true;
        cbi = 0;
        emit();
        for (t in transitions) {
            t.setup();
        }
        update(offset);
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