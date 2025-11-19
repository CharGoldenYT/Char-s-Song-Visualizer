package data.song;

import data.song.FileHandler.BaseMetadata;
import sys.Paths.getPath;
import openfl.media.Sound;
import flixel.util.FlxStringUtil;

class SongHandler {
    /** This is the currently playing song, making it easy to change on the fly. */
    public static var curPlayingSong:FlxSound = null;
    public static var songCache:Map<String, Sound> = new Map();

    // Call this to load the data AND the songs.
    public static function init()
    {
        FileHandler.initSongData();
        for (data in FileHandler.cachedData)
        {
            var path:String = getPath('${data.path.split(".")[0]}.ogg', 'songs/', false);
            songCache.set(path, Sound.fromFile(path));
        }
    }

    public static function loadSong()
    {
        final data = FileHandler.curSongData;
        if (data.name == "No Song Loaded")
        {
            return;
        }
        if (curPlayingSong != null)
        {
            curPlayingSong.stop();
            FlxG.sound.list.remove(curPlayingSong, true);
            curPlayingSong.destroy();
        }

        curPlayingSong = new FlxSound().loadEmbedded(songCache.get(getPath('${data.path.split(".")[0]}.ogg', 'songs/', false)));
        FlxG.sound.list.add(curPlayingSong);
        curPlayingSong.onComplete = function(){
            onComplete(next());
        };
    }

    public static function clearSongs()
    {
        stop();
        listPosition = 0;
        curPlayingSong.destroy();
        FileHandler.clear_and_reinit(false);
        songCache.clear();
        init();
    }

    public static function getSong():Null<FlxSound>
    {
        return curPlayingSong;
    }

    public static function play() curPlayingSong.play();
    public static function pause() curPlayingSong.pause();
    public static function stop() curPlayingSong.stop();
    public static var onComplete:Null<BaseMetadata> -> Null<BaseMetadata>;
    public static function next():Null<BaseMetadata>
    {
        stop();
        if (FileHandler.curPlaylist != null)
        {
            var curList = FileHandler.curPlaylist;
            listPosition++;
            if (curList.songs[listPosition] != null)
            {
                FileHandler.curSongData = curList.songs[listPosition];
                loadSong();
                return curList.songs[listPosition];
            }
        }
        clearSongs();
        return null;
    }
    public static function last()
    {
        if (listPosition == 0) return;
        stop();
    }
    public static var listPosition:Int = 0;
    public static var curTime(get, null):Float;
    public static var songLength(get, null):Float;
    public static var songPercent(get, null):Float;
    public static var songTimeText(get, null):String;
    static function get_curTime():Float return curPlayingSong.time;
    static function get_songLength():Float return curPlayingSong.length;
    static function get_songPercent():Float return (curPlayingSong.time / curPlayingSong.length);
    static function get_songTimeText():String return '${FlxStringUtil.formatTime(curTime / 1000)} : ${FlxStringUtil.formatTime(songLength / 1000)}';
    public static function update(elapsed:Float)
    {
        if (curPlayingSong != null)
            curPlayingSong.update(elapsed);
    }
}