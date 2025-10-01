package states;

import backend.SongData;
import backend.SongData.Repr_SongData;
import openfl.Lib;

class InitState extends BaseState
{
    var timer:FlxTimer;
    var text:FlxText;

    public override function create() {
        super.create();
        
        text = new FlxText(0, 0, 0, "Loading Song Metadata, Please Wait!", 20);
        add(text);
        trace("Loading song metadata!");

        #if !ALLOW_CACHING
        trace("No song metadata to load!");
		#else
		refreshSongList();

		for (song in SongData.dataArray)
		{
			var s:FlxSound = new FlxSound().loadEmbedded(Paths.song(song.path));
		}
		trace(SongData.songCache);
        #end
        
        trace("Finished loading song metadata");
        text.text = "Finished Loading, Going to menu in 5 seconds";

        timer = new FlxTimer().start(5, (_)->{
            FlxG.switchState(new SongSelector());
        });

        Lib.application.window.width = Main.app.width;
        Lib.application.window.height = Main.app.height;

        FlxG.autoPause = false; // This is so you can leave it in the background!
    }

	function refreshSongList()
		SongSelector.refreshSongList();

    public override function update(elapsed:Float) {
        super.update(elapsed);

        text.text = 'Finished Loading, Going to menu in ${Math.round(timer.timeLeft)} seconds';
    }
}