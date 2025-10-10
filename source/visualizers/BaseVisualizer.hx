package visualizers;

import backend.SongHandler;
import backend.SongData;
import backend.SongData.Repr_Playlist;
import backend.SongData.Repr_SongData;

typedef VizID = {
    var songData:Repr_SongData;
    @:optional var playlistData:Repr_Playlist;
    var vizName:String;
}

/*
* This class handles and provides a backend to make your own custom visualizers!
*/
class BaseVisualizer extends FlxSpriteGroup
{
    public var visualizerID:VizID;
    @:isVar var songData(get, set):Repr_SongData;
    @:isVar var playlistData(get, set):Repr_Playlist;
    public var curSong(get, null):FlxSound;

    function get_curSong():FlxSound return SongHandler.curSong;
    function get_songData():Repr_SongData return visualizerID.songData;
    function get_playlistData():Repr_Playlist return visualizerID.playlistData;
    function set_songData(d:Repr_SongData):Repr_SongData
    {
        SongData.loadedData = d;
        visualizerID.songData = d;
        return d;
    }
    function set_playlistData(d:Repr_Playlist):Repr_Playlist
    {
        SongData.loadedPlaylist = d;
        visualizerID.playlistData = d;
        return d;
    }

    /*
    * Creates a new Base Visualizer instance
    *
    * @param offset Specify an offset FlxPoint (Similar to o.offset = offset)
    * @param vizName The name of this particular visualizer
    * @param songData The current song (For display purposes)
    * @param playlistData The current playlist (For display purposes)
    */
    public function new(vizName:String, songData:Repr_SongData, ?playlistData:Repr_Playlist = null, ?offset:FlxPoint = null)
    {
        super();
        if (offset != null) this.offset = offset;
        visualizerID = {songData: songData, playlistData: playlistData, vizName: vizName};
    }

    public function close()
    {
        destroy();
    }

    public function create() {}
    public function createPost() {}
    public function updatePost(elapsed:Float) {}
}