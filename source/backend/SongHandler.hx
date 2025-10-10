package backend;

import lime.utils.UInt8Array;
import openfl.utils.ByteArray;
import haxe.io.BytesBuffer;
import lime.media.AudioBuffer;
import openfl.media.Sound;
import openfl.utils.Assets;

class SongHandler
{
    public static var curSong:FlxSound;

    public static var onUpdate:Float->Void = (_)->{};
    @:isVar public static var time(get, set):Float;
    static function set_time(f:Float):Float 
    {
        if (curSong != null) return curSong.time = f;
        return f;
    }
    static function get_time():Float return curSong.time;
    public static var length(get, null):Float;
    static function get_length():Float
    {
        if (curSong != null) return curSong.length;
        return 0;
    }
    public static var isLooping:Bool = false;

    public static function initialize(?loop:Bool = false, ?songTimeCallback:Null<Float->Void>)
    {
        curSong = SongData.loadSong(loop);

        isLooping = loop;        
        if (songTimeCallback != null) onUpdate = songTimeCallback;
        FlxG.sound.list.add(curSong);
    }

    /*
    * Creates a new curSong instance, with the option of changing the onUpdate function.
    */
    public static function reset_curSong(?songTimeCallback:Null<Float->Void> = null)
    {
        curSong.stop();
        curSong.destroy();
        initialize(isLooping, songTimeCallback);
    }
    
    static var frames:Float = 0;
    public static function update(elapsed:Float)
    {
        frames++;
        if (frames == FlxG.updateFramerate)
            onUpdate(curSong.time / 1000);
    }
}