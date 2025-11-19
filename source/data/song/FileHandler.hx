package data.song;

// Functions/Variables.
import sys.Paths.getPath;
import sys.Paths.songPlaylistFolder;
import sys.Paths.multiME;
import sys.Paths.listMetadataFiles;
import sys.Paths.listPlaylistFiles;
// Classes
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

// Backwards Compatible Typedefs.
@:deprecated("Use data.song.BaseMetadata!")
typedef Repr_SongData = BaseMetadata; 
@:deprecated("Use data.song.PlaylistMetadata!")
typedef Repr_Playlist = PlaylistMetadata;
typedef MultiSongData = {var data:Array<BaseMetadata>;};

// Main Typedefs.
typedef BaseMetadata = {
    var name:String;
    var artists:Array<String>;
    var album:String;
    /** todo: auto find file */
    @:optional var path:String;
    @:optional var bpm:Null<Int>;
	/** For extra behaviour that is modded in */
	@:optional var extraMetadata:Array<Dynamic>;
}

typedef PlaylistMetadata = {
	var songs:Array<BaseMetadata>;
	var listName:String;
	var listCreator:String;
	@:optional var extraMetadata:Array<Dynamic>;
}

final defaultData:BaseMetadata = {
        name: "No Song Loaded",
        artists: ["None"],
        album: "None",
        path: null
    };

final defaultList:PlaylistMetadata = {
		songs: [],
		listName: "No Playlist",
		listCreator: "None"
	};

/**
 * This class handles all of the REAL backend shiz. loading the data behind what makes the funny sounds play.
 */
class FileHandler
{
    public static var curSongData:BaseMetadata = defaultData;
    public static var cachedData:Array<BaseMetadata> = [];
    public static var mappedData:Map<String, BaseMetadata> = [];

    public static var curPlaylist:PlaylistMetadata = defaultList;
    public static var cachedLists:Array<PlaylistMetadata> = [];
    public static var mappedLists:Map<String, PlaylistMetadata> = [];

    public static function initSongData()
    {
        for (file in listMetadataFiles())
        {
            var rawJson = File.getContent(getPath(file, "data/songMetadata/", false));

            if (file.contains(multiME))
            {
                final songs:MultiSongData = cast Json.parse(rawJson);
                for (data in songs.data)
                {
                    cachedData.pushUnique(data);
                    mappedData.set(data.path, data);
                }
            }
            else
            {
                final data:BaseMetadata = cast Json.parse(rawJson);
                cachedData.pushUnique(data);
                mappedData.set(data.path, data);
            }
        }

        for (file in listPlaylistFiles())
        {
            var rawJson = File.getContent(songPlaylistFolder(file));
            final data:PlaylistMetadata = cast Json.parse(rawJson);
            cachedLists.pushUnique(data);
            mappedLists.set(data.listName, data);
        }
    }

    public static function getSongData(path:String):Null<BaseMetadata>
    {
        curSongData = mappedData.get(path);
        if (curSongData == null)
        {
            curSongData = defaultData;
            return null;
        }

        return curSongData;
    }

    public static function getPlaylist(name:String):Null<PlaylistMetadata>
    {
        curPlaylist = mappedLists.get(name);
        if (curPlaylist == null)
        {
            curPlaylist = defaultList;
            return null;
        }

        return curPlaylist;
    }
    
    public static function clear_and_reinit(reinit:Bool = true)
    {
        curSongData = defaultData;
        curPlaylist = defaultList;
        cachedLists = [];
        cachedData = [];
        mappedData.clear();
        mappedLists.clear();
        if (reinit) initSongData();
    }
}