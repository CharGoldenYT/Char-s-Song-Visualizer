package states;

import flixel.util.FlxColor;
import flixel.FlxState;

class BaseState extends FlxState
{
    public var controls(get, null):Controls;
    function get_controls():Controls return Controls.instance;
	public function newCam(x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0, zoom:Float = 0, bgColor:FlxColor = FlxColor.BLACK, bgAlpha:Float = 1,
			defaultDraw:Bool = false, target:FlxObject = null):FlxCamera
	{
		var newCam:FlxCamera = new FlxCamera(x, y, width, height, zoom);
		FlxG.cameras.add(newCam, defaultDraw);
		newCam.bgColor = bgColor;
		newCam.bgColor.alphaFloat = bgAlpha;
		if (target != null)
			newCam.follow(target, LOCKON, 0.06);

		return newCam;
	}

	public function newBlankCam(defaultDraw:Bool = false, target:FlxObject = null):FlxCamera
	{
		var newAlpha = defaultDraw ? 1 : 0;
		return newCam(0, 0, 0, 0, 0, 0xFF000000, newAlpha, defaultDraw, target);
	}
}