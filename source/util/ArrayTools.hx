package util;

using util.ArrayTools;

class ArrayTools {
    public static function itemsContain(a:Array<String>, s:String):Bool
    {
        for (str in a)
        {
            if (str.contains(s)) return true;
        }

        return false;
    }

    public static function get_itemContaining(a:Array<String>, s:String):Null<String>
    {
        for (str in a)
        {
            if (str.contains(s)) return str;
        }

        Logs.trace("Array does not contain `" + s + "` in any of it's strings!");
        return null;
    }

	/**
    * Takes an array of Strings and makes them all lowercase. pretty simple.
    */
    public static function lowercased(a:Array<String>):Array<String>
    {
        var lArray:Array<String> = [];

        for (s in a)
        {
            lArray.push(s.toLowerCase());
        }

        return lArray;
    }

	/**
	 * Pushes an item ONLY if it is not already present.
	 */
    public static function pushUnique<T>(a:Array<T>, o:T):Int
    {
        if (!a.contains(o)) return a.push(o); else return a.length;
    }

    public static function appendItemsFrom<T>(a:Array<T>, b:Array<T>):Array<T>
    {
        var newArray = a;
        for (i in b)
        {
            newArray.pushUnique(i);
        }

        a = newArray;
        return newArray;
    }
}