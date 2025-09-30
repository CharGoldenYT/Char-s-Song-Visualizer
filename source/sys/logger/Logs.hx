package sys.logger; // This is MY log script, so it's under charengine :3c - CharGoldenYT

import haxe.Log;
import haxe.PosInfos;
import lime.app.Application;
import sys.logger.AnsiColors;
import sys.logger.Level;

using sys.logger.LogTools;

class Logs
{
	public static var nativeTrace = Log.trace;

    public static function init()
    {
        Log.trace = traceOverride;
    }

    public static dynamic function trace(v:Dynamic, level:Level = NONE, ?infos:PosInfos):Void traceNew(v, level, infos);

    static function levelToInt(l:Level):Int
    {
        switch(l)
        {
            case INFO:
                return 0;
            case MISC:
                return 1;
            case NONE:
                return 2;
            case WARNING:
                return 3;
            case ERROR:
                return 4;
        }
    }

    static function traceOverride(v:Dynamic, ?infos:PosInfos):Void traceNew(v, NONE, infos);

    public static function traceNew(v:Dynamic, level:Level = NONE, ?infos:PosInfos):Void
    {
        #if ORIGINAL_TRACESTYLE
        trace(v, infos);
        return;
        #end
        
        var str = '${level.levelToString()} : ' + Log.formatOutput(v, infos).replace('\n\n', '\n').replace('\n', '\n${level.levelToString()} : ${infos.fileName}:${infos.lineNumber}: ') + AnsiColors.Reset;
        #if js
        if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
            (untyped console).log(str);
        #elseif lua
        untyped __define_feature__("use._hx_print", _hx_print(str));
        #elseif sys
        Sys.println(str);
        #else
        throw new haxe.exceptions.NotImplementedException()
        #end
    }
}