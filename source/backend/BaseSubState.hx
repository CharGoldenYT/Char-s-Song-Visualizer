package backend;

import flixel.FlxSubState;

class BaseSubState extends FlxSubState
{
    public var controls(get, null):Controls;
    function get_controls():Controls return Controls.instance;
}