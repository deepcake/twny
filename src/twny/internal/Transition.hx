package twny.internal;

interface Transition {
    function reset():Void;
    function apply(v:Float):Void;
}