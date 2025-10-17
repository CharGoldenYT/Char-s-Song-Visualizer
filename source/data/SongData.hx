package data;

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
	@:optional var extraMetadata:Array<Dynamic>; // For extra behaviour that is modded in
}

typedef Repr_Playlist =
{
	var mmdf:MultiSongData;
	var listName:String;
	var listCreator:String;
	@:optional var extraMetadata:Array<Dynamic>;
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

	public static var loadedPlaylist:Repr_Playlist = {
		mmdf: null,
		listName: "No Playlist",
		listCreator: "None"
	};

    public static var dataArray:Array<Repr_SongData> = [];
	public static var songCache:Map<String, Sound> = [];
	public static var listArray:Array<Repr_Playlist> = [];

    public static function loadSongMetadataFromFile(path:String):Repr_SongData
    {
        if (!FileSystem.exists(path))
            return defaultData();

        var file = File.getContent(path);
        var data:Repr_SongData = cast Parser.parse(file);
        if (data.path == null)
        {
            var splitPath:Array<String> = path.split("/");
			data.path = splitPath[splitPath.length - 1].split('.')[0];
        }
        dataArray.pushUnique(data);

        return data;
    }

	public static function loadSong(?loop:Bool = false):FlxSound
    {
		// trace('assets/songs/${loadedData.path}');
		var curSong:FlxSound = new FlxSound().loadEmbedded(Paths.song(loadedData.path), loop);

        return curSong;
    }

	public static function loadPlaylist(path:String):Repr_Playlist
	{
		if (!FileSystem.exists(path))
			return defaultList();

		var file = File.getContent(path);
		var list:Repr_Playlist = cast Parser.parse(file);
		listArray.pushUnique(list);

		return list;
	}

    public static function reset_loadedData()
    {
		loadedData = {
			name: "No Song Loaded",
			artists: ["None"],
			album: "None",
			path: null
		};
		loadedPlaylist = {
			mmdf: null,
			listName: "No Playlist",
			listCreator: "None"
		};
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

	public static function defaultList():Repr_Playlist
	{
		return {
			mmdf: null,
			listName: "No Playlist",
			listCreator: "None"
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
		songCache = [];
        dataArray = [];
		listArray = [];
    }
}