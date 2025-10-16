package;

import sys.Watermark;
import backend.SettingsHandler;
import sys.FileSystem;
import Sys;
import backend.Controls;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.InitState as TitleState;

class Main extends Sprite
{
	public static var app = {
		width: 1280,
		height: 720,
		initialState: TitleState,
		scale: 1.0,
		fps: 60,
		skipSplash: true,
		startFullscreen: false,
	}

	public static var args:Array<String>;
	public static var appletMode:Bool = false; // Not TRUE applet, but moreso a minimized version for streaming with.
	public static var verWatermark:Watermark;

	public static var instance:Main;

	public static var curGame:FlxGame;
	public function new()
	{
		super();
		args = Sys.args().lowercased();
		trace(args);
		initShit();
		addChild(curGame = new FlxGame(app.width, app.height, app.initialState, app.fps, app.fps, app.skipSplash, app.startFullscreen));
	}

	function initShit()
	{
		var lwArg:String = args.get_itemContaining("width");
		var lhArg:String = args.get_itemContaining("height");
		var lAppltArg:String = args.get_itemContaining("applet");

		if (lwArg != null)
		{
			app.width = Std.parseInt(lwArg.split("=")[1]);
		}
		if (lhArg != null)
		{
			app.height = Std.parseInt(lhArg.split("=")[1]);
		}
		if (lAppltArg != null)
		{
			appletMode = true;
			app.scale = 0.5;
			if (lwArg == null) app.width = 600;
			if (lhArg == null) app.height = 300;
		}

		#if !ORIGINAL_TRACESTYLE
		Logs.init();
		#end
		new Controls();
		if (!FileSystem.exists("externSongs/"))
		{
			FileSystem.createDirectory("externSongs/");
		}
		SettingsHandler.loadConfig();
		instance = this;
	}
}
