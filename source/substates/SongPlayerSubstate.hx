package substates;

import flixel.util.FlxStringUtil;
import states.SongSelector;
import backend.SongData;

class SongPlayerSubstate extends BaseSubState
{
	var playerBG:FlxSprite;
	var timeTxt:FlxText;
	var curSong:FlxSound;
	var song:Repr_SongData;
	var songText:FlxText;
    var isLooped:Bool = false;
	var isPaused(get, null):Bool;
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
		if (!Main.appletMode)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			bg.alpha = 0.5;
			add(bg);
		}

		this.cameras = [SongSelector.instance.camMusic];

		curSong = SongData.loadSong(isLooped);
		FlxG.sound.list.add(curSong);

		var bw:Int = 300;
		var bh:Int = 150;

		if (!Main.appletMode)
		{
			bw = 600; bh = 300;
		}
		playerBG = new FlxSprite().makeGraphic(bw, bh, 0xFFCC66DD);
		add(playerBG);
		playerBG.y = FlxG.height - playerBG.height;

		curSong.play();
		if (!isLooped) curSong.onComplete = ()->close();

		var songText:FlxText = new FlxText(0, 0, 0, "", 20);
		songText.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		songText.y = playerBG.y + ((playerBG.height * 0.5) - songText.height) - 30;
		add(songText);
		song = SongSelector.instance.songList[SongSelector.instance.curSelected];
		songText.text = '${song.name}\n${song.album}\n${formatArtists(song.artists)}';

		DiscordClient.changePresence('${song.name} | ${song.album} | ${formatArtists(song.artists)}');

		timeTxt = new FlxText(0, 0, 0, "0:00 / " + FlxStringUtil.formatTime(curSong.length / 1000), 20);
		timeTxt.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		timeTxt.y = songText.y + 75;
		add(timeTxt);
	}

	function formatArtists(a:Array<String>):String
	{
		var s:String = "";
		for (artist in a)
		{
			s += artist + " | ";
		}

		var split = s.split("");
		s = "";
		for (i in 0...split.length-2)
		{
			s += split[i];
		}
		return s;
	}

	public override function close() {
		curSong.stop();
		SongSelector.instance.bg.alpha = 1;
		SongSelector.instance.catText.alpha = 1;
		DiscordClient.changePresence();
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

		timeTxt.text = '${FlxStringUtil.formatTime(curSong.time / 1000)} : ${FlxStringUtil.formatTime(curSong.length / 1000)}';

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