package states;

import substates.VisualizerSubstate;
import data.song.FileHandler;
import util.ObjectGroup;
import data.song.FileHandler.cachedData;
import data.song.FileHandler.cachedLists;
import data.song.SongHandler;

class SongSelectionState extends BaseState
{
	public static var instance:SongSelectionState;

	var bg:FlxSprite;
	var altBG:FlxSprite;
	var grpSongs:ObjectGroup<FlxText>;// todo: Make this a SongBacker class when that's ready.

	var catText:FlxText;
	var tabs:Array<String> = ["songs", "playlists"];
	var curSelected:Int = 0;
	var curTab:Int = 0;

	var camFollow:FlxObject;
	var camBG:FlxCamera;
	var camSongs:FlxCamera;
	public var camViz:FlxCamera;

	public override function create() {
		super.create();
		persistentDraw = true;
		persistentUpdate = true; // FUCK YOU THIS SHOULD ALWAYS BE UPDATING.

		camFollow = new FlxObject();
		camFollow.screenCenter(X);
		camBG = newBlankCam(true);
		camSongs = newBlankCam(false, camFollow);
		camSongs.zoom = 1.3;
		camViz = newBlankCam();
		
		altBG = new FlxSprite().loadGraphic(Paths.image("DesatBG"));
		altBG.antialiasing = true;
		add(altBG);

		bg = new FlxSprite().loadGraphic(Paths.image("SongSelectorBG"));
		bg.antialiasing = true;
		add(bg);

		grpSongs = new ObjectGroup<FlxText>();
		grpSongs.cameras = [camSongs];
		add(grpSongs);

		var pos:Int = -1;
		for (k => song in cachedData)
		{
			pos++;
			var s:String = '${song.name}\n${song.album}';
			var text:FlxText = new FlxText(0, 60 * pos, FlxG.width, s, 20);
			text.setFormat(Paths.font("UbuntuMB.ttf"), 20, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
			grpSongs.add(text);
			text.antialiasing = true;
		}

		changeSelection();
		instance = this;
		DiscordClient.changePresence();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));

		var curList:Array<Dynamic> = switch (tabs[curTab]) {
			case "playlists":
				cachedLists;
			default:
				cachedData;
		};
		var listLength:Int = curList.length;

		curSelected += change;
		if (curSelected > listLength - 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = listLength - 1;

		grpSongs.forEachIndexed((member, i)->{
			if (i == curSelected)
			{
				member.alpha = 1;
				camFollow.y = member.y;
			}
			else
			{
				member.alpha = 0.5;
			}
		});
	}

	var inVisualizer:Bool = false;
	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		SongHandler.update(elapsed);

		if (!inVisualizer)
		{
			if (controls.CONFIRM)
			{
				playSong();
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
				//changeTabs(-1);
			}
			if (controls.TAB_RIGHT)
			{
				//changeTabs(1);
			}
			if (controls.RELOAD)
			{
				FileHandler.clear_and_reinit();
				FlxG.resetState();
			}
		}
		else
		{
			if (controls.BACK)
			{
				SongHandler.stop();
				SongHandler.onComplete(SongHandler.next());
			}
		}
	}

	// Fuck it we move it to this state.
	function playSong()
	{
		inVisualizer = true;
		bg.visible = false;
		camSongs.visible = false;
		if (tabs[curTab] != 'playlists')
		{
			FileHandler.getSongData(cachedData[curSelected].path);
			SongHandler.loadSong();
			SongHandler.play();
			SongHandler.onComplete = function (next:Null<BaseMetadata>):Null<BaseMetadata> {
				inVisualizer = false;
				bg.visible = true;
				camSongs.visible = true;
				closeSubState();
				return next;
			}
		}

		openSubState(new VisualizerSubstate());
	}
}