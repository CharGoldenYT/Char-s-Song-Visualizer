package substates;

import backend.SongHandler;
import visualizers.BaseVisualizer;
import flixel.util.FlxStringUtil;
import states.SongSelector;
import backend.SongData;

class SongPlayerSubstate extends BaseSubState
{
	var curSong(get, null):FlxSound;

	function get_curSong():FlxSound
		return SongHandler.curSong;
	var song:Repr_SongData;
    var isLooped:Bool = false;
	var isPaused(get, null):Bool;
	var curVisualizer:BaseVisualizer;
	function get_isPaused():Bool
	{
		return !(curSong.playing ?? true);
	}

    public function new(?loop:Bool = false)
    {
        super();
        isLooped = loop;
    }

	public override function create() {
		super.create();
		if (Paths.song(SongData.loadedData.path) == null)
		{
			close();
			SongSelector.instance.openSubState(new CoolErrorSubstate("That path is not a supported file type on desktop, or points to a file that does not exist!",
				"Error playing song!", null, 3, false));
		}
		if (!Main.appletMode)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			bg.alpha = 0.5;
			add(bg);
		}

		SongHandler.initialize(isLooped);

		this.cameras = [SongSelector.instance.camMusic];

		/* curVisualizer = getVisualizer(SongData.loadedData.path);
			add(curVisualizer);
			curVisualizer.create(); */

		curSong.play();
		if (!isLooped) curSong.onComplete = ()->close();

		DiscordClient.changePresence('${song.name} | ${song.album} | ${ArrayTools.formatArtists(song.artists)}');

		curVisualizer.createPost();
	}

	function getVisualizer(id:String):BaseVisualizer
	{
		switch (id)
		{
			default:
				return new visualizers.RecordVisualizer("Record Visualizer", SongData.loadedData, SongData.loadedPlaylist);
		}
	}

	public override function close() {
		curSong.stop();
		SongSelector.instance.bg.alpha = 1;
		SongSelector.instance.catText.alpha = 1;
		DiscordClient.changePresence();
		curVisualizer.close();
		super.close();
	}

    public function re_init()
    {
        curSong.stop();
		close();
		SongSelector.instance.openSubState(new SongPlayerSubstate(isLooped));
    }


	public override function update(elapsed:Float) {
		super.update(elapsed);

		curVisualizer.update(elapsed);

		if (controls.LEFT_P)
		{
			skipTime(-10);
		}
		if (controls.RIGHT_P)
		{
			skipTime(10);
		}
		if (controls.CONFIRM)
		{
			pause();
		}
		if (controls.BACK)
		{
			close();
		}
		curVisualizer.updatePost(elapsed);
	}

	public function pause()
	{
		if (isPaused)
			curSong.play();
		else
			curSong.pause();
	}

	public function skipTime(seconds:Int)
	{
		var milliseconds:Int = Math.floor(seconds * 1000);

		var wasPaused:Bool = isPaused;
		curSong.pause();
		var refrTime = curSong.time + milliseconds;
		if (refrTime < 0)
			refrTime = 0;
		if (refrTime > curSong.length)
			refrTime = curSong.time;
		curSong.time = refrTime;

		if (!wasPaused) curSong.play();
	}
}