package states;

import flixel.util.FlxSignal;
import flixel.FlxSubState;
import flixel.FlxState;

class BaseState extends FlxState
{
    public var controls(get, null):Controls;
    function get_controls():Controls return Controls.instance;
	public var postSubStateClosed:FlxSignal = new FlxSignal();

	public override function closeSubState()
	{
		super.closeSubState();

		postSubStateClosed.dispatch();
	}
}