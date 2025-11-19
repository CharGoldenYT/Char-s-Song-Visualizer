package util;

/**
 * Yuh.
 */
class ObjectGroup<T:FlxBasic> extends FlxTypedGroup<T>
{
    public function forEachIndexed(func:(T, Int)->Void)
    {
        for (i in 0...members.length)
        {
            func(members[i], i);
        }
    }
}