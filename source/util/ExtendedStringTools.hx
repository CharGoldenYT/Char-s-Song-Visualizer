package util;

using StringTools;

class ExtendedStringTools
{
    /*
    * Returns a bool based on if the string is `true` or `false`
    * If it isn't purely `true` or `false`, the result is `null`
    */
    public static function parseBool(s:String):Null<Bool>
    {
        if (s == null)
        {
			tracen("String is null!", ERROR);
            return null;
        }
        if (s.toLowerCase() == "true") return true;
        else if (s.toLowerCase() == "false") return false;
        else return null;
    }
	public static function parseInt(s:String):Int
		return Std.parseInt(s);

	public static function parseFloat(s:String):Float
		return Std.parseFloat(s);
}