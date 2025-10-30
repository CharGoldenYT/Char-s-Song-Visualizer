package sys;

import flixel.util.FlxAxes;
import openfl.text.TextField;
import openfl.text.TextFormat;

/*
* This class let's you put an entire watermark over the screen.
*/
class Watermark extends TextField
{
    public function new(s:String, color:Int = 0xFFFFFFFF, size:Int = 100)
    {
		super();

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('UbuntuMR.ttf'), size, color);
		autoSize = CENTER;
		multiline = true;
		text = s;
        alpha = 0.3;
    }

    public function screenCenter(axes:FlxAxes = XY):Watermark
	{
		if (axes.x)
			x = (FlxG.width - width) / 2;

		if (axes.y)
			y = (FlxG.height - height) / 2;

		return this;
	}
}