package sys;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

class Controls
{
    public static var controlConfig:Map<String, Array<FlxKey>> = [
        "LEFT" => [LEFT, A],
        "RIGHT" => [RIGHT, D],
        "UP" => [UP, W],
        "DOWN" => [DOWN, S],

        "TAB_LEFT" => [Q, ONE],
        "TAB_RIGHT" => [E, THREE],
        "CONFIRM" => [ENTER, SPACE],
		"BACK" => [ESCAPE, BACKSPACE],
		"RELOAD" => [R]
    ];

    public var LEFT_P(get, null):Bool;
    public var RIGHT_P(get, null):Bool;
    public var UP_P(get, null):Bool;
    public var DOWN_P(get, null):Bool;
    public var TAB_LEFT(get, null):Bool;
    public var TAB_RIGHT(get, null):Bool;
    public var CONFIRM(get, null):Bool;
    public var BACK(get, null):Bool;
	public var RELOAD(get, null):Bool;

    public var LEFT(get, null):Bool;
    public var RIGHT(get, null):Bool;
    public var UP(get, null):Bool;
    public var DOWN(get, null):Bool;

    public var LEFT_R(get, null):Bool;
    public var RIGHT_R(get, null):Bool;
    public var UP_R(get, null):Bool;
    public var DOWN_R(get, null):Bool;

    function get_LEFT_P():Bool return justPressed("LEFT");
    function get_RIGHT_P():Bool return justPressed("RIGHT");
    function get_UP_P():Bool return justPressed("UP");
    function get_DOWN_P():Bool return justPressed("DOWN");
    function get_TAB_LEFT():Bool return justPressed("TAB_LEFT");
    function get_TAB_RIGHT():Bool return justPressed("TAB_RIGHT");
    function get_CONFIRM():Bool return justPressed("CONFIRM");
    function get_BACK():Bool return justPressed("BACK");
	function get_RELOAD():Bool
		return justPressed("RELOAD");

    function get_LEFT():Bool return pressed("LEFT");
    function get_RIGHT():Bool return pressed("RIGHT");
    function get_UP():Bool return pressed("UP");
    function get_DOWN():Bool return pressed("DOWN");

    function get_LEFT_R():Bool return justReleased("LEFT");
    function get_RIGHT_R():Bool return justReleased("RIGHT");
    function get_UP_R():Bool return justReleased("UP");
    function get_DOWN_R():Bool return justReleased("DOWN");
 
    public function justPressed(key:String):Bool
        return FlxG.keys.anyJustPressed(controlConfig[key]);

    public function justReleased(key:String):Bool
        return FlxG.keys.anyJustReleased(controlConfig[key]);

    public function pressed(key:String):Bool
        return FlxG.keys.anyPressed(controlConfig[key]);

    public static function saveControls()
    {
        var controls:FlxSave = new FlxSave();
        controls.bind("SV_Controls-0_0_1", Constants.saveFolder);
        
        controls.data.keybinds = controlConfig;
    }

    public static function loadControls()
    {
        var controls:FlxSave = new FlxSave();
        controls.bind("SV_Controls-0_0_1", Constants.saveFolder);

        if (controls.isEmpty()) return; // Dont go any further if it's literally empty lmao.
        var map:Map<String, Array<FlxKey>> = controls.data.keybinds;
        for (key => control in map)
        {
            if (controlConfig.exists(key)) controlConfig.set(key, control);
        }
    }

    public static var instance:Controls;
    public function new()
    {
        loadControls();

        instance = this;
    }
}