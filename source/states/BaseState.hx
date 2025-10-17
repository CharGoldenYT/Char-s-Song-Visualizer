package states;

import flixel.FlxState;

class BaseState extends FlxState
{
    public var controls(get, null):Controls;
    function get_controls():Controls return Controls.instance;
}