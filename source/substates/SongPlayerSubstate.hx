package substates;

import flixel.util.FlxStringUtil;
import states.SongSelector;
import data.SongData;
import flixel.math.FlxMath;

import flixel.ui.FlxBar;

typedef Playlist =
{
	var data:Repr_Playlist;
	var shuffle:Bool;
	var loop:Bool;
}

class SongPlayerSubstate extends BaseSubState
{
	var playerBG:FlxSprite;
	var timeTxt:FlxText;
	static var curSong:FlxSound;
	var song:Repr_SongData;
	var songText:FlxText;
    var isLooped:Bool = false;
	var isPaused(get, null):Bool;
	var songPercent:Float;
	public static var curPlaylist:Playlist = null;

	var songIndex:Int = 0;
	
	var timeBar:FlxBar;
	var timeControl:FlxSprite;

	function get_isPaused():Bool
	{
		return !(curSong.playing ?? true);
	}

	function nextSong():Repr_SongData
	{
		if (curPlaylist == null)
		{
			if (!isLooped)
				close(); // fun fact this means it was a singular song that was loaded.
			return null;
		}
		var pl_data:Array<Repr_SongData> = curPlaylist.data.mmdf.data;
		var song:Repr_SongData;

		if (curPlaylist.shuffle)
		{
			if (!curPlaylist.loop)
				curPlaylist.data.mmdf.data.splice(pl_data.indexOf(SongData.loadedData), 1);
			var int = FlxG.random.int(0, pl_data.length - 1);
			song = pl_data[int];
			if (song.path == SongData.loadedData.path)
			{
				if (int == pl_data.length)
					song = pl_data[int - 1];
				else
					song = pl_data[int + 1];
			}
		}
		else
		{
			songIndex++;
			if (songIndex > pl_data.length - 1)
			{
				if (!curPlaylist.loop)
					close();
				else
					songIndex = 0;
			}

			song = pl_data[songIndex];
		}

		return song;
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

		var loopIt:Bool = (isLooped && (curPlaylist == null));
		curSong = SongData.loadSong(loopIt);
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
		curSong.onComplete = () ->
			{
				var data = nextSong();
			if (curPlaylist != null)
			{
				if (data != null)
				{
					curSong.destroy();
					SongData.loadedData = data;
					curSong = SongData.loadSong();
					curSong.play();
					FlxG.sound.list.add(curSong);
				}
			}
			};

		var songText:FlxText = new FlxText(0, 0, 0, "", 20);
		songText.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		songText.y = playerBG.y + ((playerBG.height * 0.5) - songText.height) - 30;
		add(songText);
		song = SongSelector.instance.songList[SongSelector.instance.curSelected];
		songText.text = '${song.name}\n${song.album}\n${formatArtists(song.artists)}';

		DiscordClient.changePresence('${song.name} | ${song.album} | ${formatArtists(song.artists)} | ${FlxStringUtil.formatTime(curSong.length / 1000)} ${isLooped ? " - Looping" : ""}');

		timeTxt = new FlxText(35, 0, 0, "0:00 / " + FlxStringUtil.formatTime(curSong.length / 1000), 20);
		timeTxt.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		timeTxt.y = songText.y + 100;

		timeBar = new FlxBar(timeTxt.x - 25, timeTxt.y + 50, LEFT_TO_RIGHT, bw - 20, 10, this, 'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800;
		add(timeBar);

		timeControl = new FlxSprite().makeGraphic(10, Std.int(timeBar.height)+10, 0xFFFFFFFF);
		timeControl.y = timeBar.y-(timeBar.height/2);
		add(timeControl);

		add(timeTxt);

		var loopSymbol:FlxSprite = new FlxSprite().loadGraphic(Paths.image("looped"));
		loopSymbol.y = songText.y + 75;
		loopSymbol.x = (timeTxt.x + timeTxt.width) + 10;
		add(loopSymbol);
		loopSymbol.color = isLooped ? 0xFFFFFFFF : 0xFF888888;
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
		curPlaylist = null;
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
		songPercent = curSong.time / curSong.length;

		if (FlxG.mouse.overlaps(timeBar)){
			if (FlxG.mouse.justPressed){
				skipTime(Std.int(FlxMath.remapToRange(FlxG.mouse.screenX, 0, timeBar.width, 0, curSong.length/1000) - curSong.time/1000));
			}
			timeControl.scale.y = timeControl.scale.y + (1.5 - timeControl.scale.y) / 2;
		}else{
			timeControl.scale.y = timeControl.scale.y + (1 - timeControl.scale.y) / 2;
		}

		timeControl.x = timeBar.x
			+ (timeBar.width * (FlxMath.remapToRange(timeBar.percent, 0, 100, 0, 100 *0.01)));

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
