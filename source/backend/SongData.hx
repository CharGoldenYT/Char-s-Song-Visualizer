package backend;

import openfl.media.Sound;
import haxe.Json as Parser;
import sys.FileSystem;
import sys.io.File;

// Used to load song data from a file.
typedef Repr_SongData = {
    var name:String;
    var artists:Array<String>;
    var album:String;
    @:optional var path:String; // todo: auto find file
    @:optional var bpm:Null<Int>;
    @:optional var ExtraMetadata:Array<Dynamic>; // For extra behaviour that is modded in
}

typedef MultiSongData = {
    var data:Array<Repr_SongData>;
}

class SongData
{
    public static var loadedData:Repr_SongData = {
        name: "No Song Loaded",
        artists: ["None"],
        album: "None",
        path: null
    };

    public static var dataArray:Array<Repr_SongData> = [];
	public static var songCache:Map<String, Sound> = [];

    public static function loadSongMetadataFromFile(path:String):Repr_SongData
    {
        if (!FileSystem.exists(path))
            return defaultData();

        var file = File.getContent(path);
        var data:Repr_SongData = cast Parser.parse(file);
        if (data.path == null)
        {
            var splitPath:Array<String> = path.split("/");
            splitPath = splitPath[splitPath.length - 1].split(".");

            data.path = splitPath[0] + '.mp3';
        }
        dataArray.pushUnique(data);

        return data;
    }

    public static function loadSong():FlxSound
    {
        trace('assets/songs/${loadedData.path}');
        var curSong:FlxSound = new FlxSound().loadEmbedded(Paths.song(loadedData.path));

        return curSong;
    }

    public static function reset_loadedData()
    {
        loadedData = defaultData();
    }

    public static function defaultData():Repr_SongData
    {
        return {
            name: "No Song Loaded",
            artists: ["None"],
            album: "None",
            path: null
        };
    }

    public static function loadMultiMetadata(path:String):Array<Repr_SongData>
    {
        var rawFile:String = File.getContent(path);
        var mmdf:MultiSongData = cast Parser.parse(rawFile);

        return loadMultiSongData(mmdf.data);
    }

    public static function loadMultiSongData(mSD:Array<Repr_SongData>):Array<Repr_SongData>
    {
        return dataArray.appendItemsFrom(mSD);
    }

    public static function resetCache()
    {
        reset_loadedData();
        dataArray = [];
    }
}