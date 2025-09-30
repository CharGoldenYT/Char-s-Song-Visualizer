package backend;

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
            Logs.trace("String is null!");
            return null;
        }
        if (s.toLowerCase() == "true") return true;
        else if (s.toLowerCase() == "false") return false;
        else return null;
    }
}