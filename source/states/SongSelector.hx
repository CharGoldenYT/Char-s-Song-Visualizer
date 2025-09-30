package states;

import flixel.util.FlxStringUtil;
import openfl.Assets;
import backend.SongData;
import backend.SongData.Repr_SongData;

class SongSelector extends BaseState 
{
	public var bg:FlxSprite;
	public var songList(get, null):Array<Repr_SongData>;
	function get_songList():Array<Repr_SongData> return SongData.dataArray;

	public var grpSongs:FlxTypedGroup<FlxText>; // to be given a specific SongBacker class.
	public var curSelected:Int = 0;
	var camFollow:FlxObject;
	var camBG:FlxCamera;
	var camMenu:FlxCamera;
	public var camMusic:FlxCamera;
	public static var instance:SongSelector;

	public override function create() {
		super.create();

		trace(Paths.listMetadataFiles());

		refreshSongList();

		camBG = new FlxCamera();
		camMenu = new FlxCamera();
		camMusic = new FlxCamera();
		camFollow = new FlxObject();
		camFollow.screenCenter(X);

		camMenu.bgColor.alpha = 0;
		camMusic.bgColor.alpha = 0;
		camMenu.scroll.y = camFollow.y;
		camMenu.scroll.x = camFollow.x;
		camMenu.follow(camFollow, LOCKON, 0.06);

		FlxG.cameras.add(camBG);
		FlxG.cameras.add(camMenu, false);
		FlxG.cameras.add(camMusic, false);

		bg = new FlxSprite().loadGraphic(Paths.image("SongSelectorBG"));
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<FlxText>();
		add(grpSongs);
		grpSongs.cameras = [camMenu];

		var pos:Int = -1;
		for (song in songList)
		{
			pos++;
			var s:String = '${song.name}\n${song.album}';
			var text:FlxText = new FlxText(0, 50 * pos, 0, s, 20);
			text.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
			grpSongs.add(text);
		}

		changeSelection();
		instance = this;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));

		curSelected += change;
		if (curSelected > songList.length -1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = songList.length -1;

		for (i in 0...songList.length)
		{
			if (i == curSelected)
			{
				var member:FlxText = grpSongs.members[i];

				member.alpha = 1;
				camFollow.y = member.y;
			}
			else
			{
				var member:FlxText = grpSongs.members[i];
				member.alpha = 0.5;
			}
		}
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.CONFIRM)
		{
			goToSongPlayer();
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}
		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.RELOAD)
		{
			FlxG.resetState();
		}
	}

	function goToSongPlayer()
	{
		// Rn it just plays the song.
		var curMetadata = songList[curSelected];
		SongData.loadedData = curMetadata;
		bg.alpha = 0;
		openSubState(new SongPlayerSubstate());
	}

	function refreshSongList()
	{
		#if ALLOW_CACHING
		SongData.resetCache();
		#end

		for (file in Paths.listMetadataFiles())
		{
			var reprFile = Paths.songMetadataFolder() + file;
			if (file.endsWith(Paths.metadataExtension))
			{
				SongData.loadSongMetadataFromFile(reprFile);
			}
			else if (file.endsWith(Paths.multiME))
			{
				SongData.loadMultiMetadata(reprFile);
			}
			else
			{
				trace('File `$reprFile` is not a valid metadata filetype! please use either `${Paths.metadataExtension}` or `${Paths.multiME}`!', WARNING);
			}
		}
	}
}

class SongPlayerSubstate extends BaseSubState
{
	var playerBG:FlxSprite;
	var timeTxt:FlxText;
	var curSong:FlxSound;
	var songText:FlxText;

	public override function create() {
		super.create();
		if (!Main.appletMode)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			bg.alpha = 0.5;
			add(bg);
		}

		this.cameras = [SongSelector.instance.camMusic];

		curSong = SongData.loadSong();
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
		curSong.onComplete = ()->close();

		var songText:FlxText = new FlxText(0, 0, 0, "", 20);
		songText.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		songText.y = playerBG.y + ((playerBG.height * 0.5) - songText.height) - 30;
		add(songText);
		var song = SongSelector.instance.songList[SongSelector.instance.curSelected];
		songText.text = '${song.name}\n${song.album}\n${formatArtists(song.artists)}';

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
		super.close();
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		timeTxt.text = '${FlxStringUtil.formatTime(curSong.time / 1000)} : ${FlxStringUtil.formatTime(curSong.length / 1000)}';

		if (controls.BACK)
		{
			close();
		}
	}
}