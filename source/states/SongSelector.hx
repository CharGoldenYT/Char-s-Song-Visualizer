package states;

import flixel.util.typeLimit.OneOfTwo;
import data.SongData;
import data.SongData.Repr_SongData;
import substates.SongPlayerSubstate;

class SongSelector extends BaseState 
{
	public var bg:FlxSprite;
	public var songList(get, null):Array<Repr_SongData>;
	function get_songList():Array<Repr_SongData> return SongData.dataArray;
	public var playlist_list(get, null):Array<Repr_Playlist>;

	function get_playlist_list():Array<Repr_Playlist>
		return SongData.listArray;

	var curList(get, null):Array<Dynamic>;

	function get_curList():Array<Dynamic>
	{
		var l:Dynamic = [songList, playlist_list];

		return l[curTab];
	}

	public var tabs:Array<String> = ["SONGS", "PLAYLISTS"];
	public var grpSongs:FlxTypedGroup<FlxText>; // to be given a specific SongBacker class.
	public var curSelected:Int = 0;
	public var curTab:Int = 0;
	var camFollow:FlxObject;
	var camBG:FlxCamera;
	var camMenu:FlxCamera;
	public var camMusic:FlxCamera;
	public var camViz:FlxCamera;
	public static var instance:SongSelector;
	public var catText:FlxText;

	public override function create() {
		super.create();

		refreshSongList();

		camBG = new FlxCamera();
		camMenu = new FlxCamera();
		camMusic = new FlxCamera();
		camFollow = new FlxObject();
		camFollow.screenCenter(X);
		camViz = new FlxCamera();

		camMenu.bgColor.alpha = 0;
		camMusic.bgColor.alpha = 0;
		camViz.bgColor.alpha = 0;
		camMenu.scroll.y = camFollow.y;
		camMenu.scroll.x = camFollow.x;
		camMenu.follow(camFollow, LOCKON, 0.06);

		FlxG.cameras.add(camBG);
		FlxG.cameras.add(camMenu, false);
		FlxG.cameras.add(camMusic, false);
		FlxG.cameras.add(camViz, false);

		bg = new FlxSprite().loadGraphic(Paths.image("SongSelectorBG"));
		add(bg);
		bg.screenCenter();

		catText = new FlxText(0, 10, FlxG.width, "(Q) < SONGS > (E)", 40);
		catText.setFormat(Paths.font("UbuntuMR.ttf"), 40, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		catText.borderSize = 3;
		add(catText);

		grpSongs = new FlxTypedGroup<FlxText>();
		add(grpSongs);
		grpSongs.cameras = [camMenu];

		var pos:Int = -1;
		for (song in songList)
		{
			pos++;
			var s:String = '${song.name}\n${song.album}';
			var text:FlxText = new FlxText(0, 60 * pos, 0, s, 20);
			text.setFormat(Paths.font("UbuntuMB.ttf"), 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
			text.ID = pos;
			grpSongs.add(text);
		}

		changeSelection();
		instance = this;
		DiscordClient.changePresence();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));

		curSelected += change;
		if (curSelected > curList.length - 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = curList.length - 1;

		grpSongs.forEach(function(member:FlxText){
			if (member.ID == curSelected){
				member.alpha = 1;
				camFollow.y = member.y;
			}else{
				member.alpha = 0.5;
			}
		});

		// for (i in 0...songList.length)
		// {
		// 	var member:FlxText = grpSongs.members[i];
		// 	if (i == curSelected)
		// 	{
		// 		member.alpha = 1;
		// 		camFollow.y = member.y;
		// 	}
		// 	else
		// 	{
		// 		member.alpha = 0.5;
		// 	}
		// }
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.CONFIRM)
		{
			goToSongPlayer(FlxG.keys.pressed.SHIFT, FlxG.keys.pressed.TAB);
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}
		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.TAB_LEFT)
		{
			changeTabs(-1);
		}
		if (controls.TAB_RIGHT)
		{
			changeTabs(1);
		}
		if (controls.RELOAD)
		{
			FlxG.resetState();
		}
	}

	function goToSongPlayer(?loop:Bool = false, ?shuffle:Bool = false)
	{
		trace(curTab);
		if (curTab == 1)
		{
			SongData.loadedPlaylist = playlist_list[curSelected];
			SongPlayerSubstate.curPlaylist = {
				data: playlist_list[curSelected],
				loop: loop,
				shuffle: shuffle
			};
		}
		SongData.loadedData = curTab == 1 ? playlist_list[curSelected].mmdf.data[0] : songList[curSelected];
		bg.alpha = 0;
		catText.alpha = 0;
		openSubState(new SongPlayerSubstate(loop));
	}

	function changeTabs(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));

		curTab += change;
		if (curTab > tabs.length - 1)
			curTab = 0;
		if (curTab < 0)
			curTab = tabs.length - 1;

		curSelected = 0;
		grpSongs.forEachAlive(function(member:FlxText) member.destroy());
		
		refreshSongList();

		catText.text = '(Q) < ${tabs[curTab]} > (E)';

		for (i in 0...curList.length)
		{
			var s:String = '';
			var isPlaylist = (curList[0].listName != null);
			var isSonglist = (curList[0].name != null);
			if (isPlaylist)
			{
				var fList:Array<Repr_Playlist> = cast curList;
				s = '${fList[i].listName}\n${fList[i].listCreator}';
			}
			else if (isSonglist)
			{
				var fList:Array<Repr_SongData> = cast curList;
				s = '${fList[i].name}\n${fList[i].album}';
			}
			var text:FlxText = new FlxText(0, 60 * i, 0, s, 20);
			text.setFormat(Paths.font("UbuntuMB.ttf"), 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
			text.ID = i;
			grpSongs.add(text);
		}

		changeSelection();
	}

	static function formatPath(pArray:Array<String>, file:String):String
	{
		switch (pArray[0])
		{
			case "assets":
				return pArray[0] + ' : ' + pArray[2] + ' : ' + file;
			case "externSongs":
				return pArray[0] + ' : ' + file;
			default:
				return pArray[0] + ' : ' + pArray[1] + ' : ' + file;
		}
	}
	public static function refreshSongList()
	{
		SongData.resetCache();

		for (file in Paths.listMetadataFiles())
		{
			var reprFile = Paths.getPath(file, "data/songMetadata/", false);
			trace(formatPath(Paths.getPathArray(file, "data/songMetadata/", false), file));
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
				tracen('File `$reprFile` is not a valid metadata filetype, please use either `${Paths.metadataExtension}` or `${Paths.multiME}`!', WARNING);
			}
		}
		for (file in Paths.listPlaylistFiles())
		{
			var reprFile = Paths.songPlaylistFolder(file);
			trace(formatPath(Paths.getPlaylistPathArray(file), file));
			if (file.endsWith(Paths.playlistExt))
				trace(SongData.loadPlaylist(reprFile));
		}
	}
}