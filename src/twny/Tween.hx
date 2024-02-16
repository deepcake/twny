package twny;

import twny.internal.FunctionTransition;
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
     * If `true` the whole tween tree will be started from the beginning after completion
     */
    @:isVar public var repeatable(get, set) = false;
    /**
     * If `true` the whole tween tree will be disposed after completion (if `repeatable == false`) or after direct calling `stop()`
     */
    @:isVar public var autodispose(get, set) = true;

    /**
     * `true` if current tween is completed (elapsed time == duration)
     */
    public var completed(get, never):Bool;

    /**
     * `true` if the whole tween tree is completed (elapsed time of each tween == duration)
     */
    public var fullyCompleted(get, never):Bool;


    /**
     * @param duration duration of current tween
     * @param once if `true` the whole tween tree will be disposed after completion (if `repeatable == false`) or after direct calling `stop`
     */
    public function new(duration:Float, once:Bool = true) {
        this.duration = duration;
        this.autodispose = once;
    }

    /**
     * Makes tween tree reusable (`autodispose = false`)
     */
    public function reuse() {
        autodispose = false;
        return this;
    }

    /**
     * Makes tween tree repeatable (the whole tween tree will be started from the beginning after completion)
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
     * __Note__ that in some cases with multilple parallel tweens the forced completed values may differ if they was completed in the regular way. 
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
        onStartCb = null;
        onUpdateCb = null;
        onCompleteCb = null;
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
     * Creates a transitions of passed _properties_ with passed _easing_ from the property's current value to the assingned value.  
     * There is also available some relativity control of the transition:  
     * - a simple assignment `obj.x = val` produces relative `from = () -> obj.x` and fixed `to = val`.  
     * - a short assingment `obj.x += val` produces relative `from = () -> obj.x` and relative `to = () -> obj.x + val`.  
     * - an equality op `obj.x == val` produces fixed `from = obj.x` and fixed `to = val`.  
     * 
     * The relative _from/to_ values are initialized each time the tween starts. The fixed _from/to_ values are initialized only once on creation.
     * @param easing `Float->Float` easing function
     * @param properties a single expression like `obj.x = 5` or a block of expressions `{ obj.x = 5; obj.y = 10; }`
     */
#if twny_autocompletion_hack // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
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
     * Creates a transitions of passed _properties_ with passed _easing_ from the property's current value to the assingned value.  
     * There is also available some relativity control:  
     * - a simple assignment `obj.x = val` produces relative `to = () -> obj.x` and fixed `from = val`.  
     * - a short assingment `obj.x += val` produces relative `to = () -> obj.x` and relative `from = () -> obj.x + val`.  
     * - an equality op `obj.x == val` produces fixed `to = obj.x` and fixed `from = val`.  
     * 
     * The relative _from/to_ values are initialized each time the tween starts. The fixed _from/to_ values are initialized only once on creation.
     * @param easing `Float->Float` easing function
     * @param properties a single expression like `obj.x = 5` or block of expressions `{ obj.x = 5; obj.y = 10; }`
     */
#if twny_autocompletion_hack // hack for autocompletion bug https://github.com/HaxeFoundation/haxe/issues/9421
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
        return transition(new FunctionTransition(easing, from, to, cb));
    }


    @:noCompletion
    public function transition(t:Transition):Tween {
        transitions.push(t);
        return this;
    }


    function setup() {
        stock();
        elapsed = 0.0;
        running = true;
        if (onStartCb != null) {
            onStartCb();
        }
        for (t in transitions) {
            t.setup();
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