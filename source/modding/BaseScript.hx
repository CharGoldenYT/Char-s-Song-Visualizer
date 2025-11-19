package modding;

import data.song.SongHandler;
import substates.VisualizerSubstate;

class BaseScript extends FlxObject
{
    public var instance:VisualizerSubstate;
    public var name:String;

    public var curSong:FlxSound;

    public function new(name:String = "Unnamed Script")
    {
        this.name = name;
        super();

        instance = VisualizerSubstate.instance;
        curSong = SongHandler.curPlayingSong;
    }
    public function onCreate() {}
    public function onCreatePost() {}
    public function onUpdatePost(elapsed:Float) {}

    public function add(o:FlxBasic):FlxBasic return instance.add(o);
}