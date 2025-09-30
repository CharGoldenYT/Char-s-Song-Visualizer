package sys;

/*
* This class recreates the functionality of a lua iterator
*/
class LuaIterator
{
    var min:Float;
    var max:Float;
    var step:Float;

	/**
	    Iterates from `min` (inclusive) to `max` (exclusive) by `step`.

	    If `max <= min`, the iterator will not act as a countdown.
        If `step` is a whole number, but `min` and/or `max` aren't, `min` and/or `max` will be `Math.floor()`'d
	**/
    public inline function new(min:Float, max:Float, step:Float = 1)
    {
        this.min = min;
        this.max = max;
        this.step = step;

        if (Std.int(step) == step)
        {
            min = Math.floor(min);
            max = Math.floor(max);
        }
    }

	/**
		Returns true if the iterator has other items, false otherwise.
	**/
    public inline function hasNext():Bool
    {
        var nextCalc:Float = min + step;

        return nextCalc < max;
    }

	/**
		Moves to the next item of the iterator.

		If this is called while hasNext() is false, the result is unspecified.
	**/
    public inline function next():Float
    {
        var nextCalc:Float = min + step;
        return (min = nextCalc);
    }
}