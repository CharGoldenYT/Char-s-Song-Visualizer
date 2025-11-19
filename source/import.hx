#if !macro
// Backend shit
import states.BaseState;
import substates.BaseSubState;
import util.Constants;
import sys.logger.Logs;
import sys.logger.Logs.traceNew as tracen;
import sys.logger.Level;
import sys.Controls;
import sys.Paths;
import sys.Paths.mkdir;
import api.Discord;
import states.SongSelectionState as SongSelector;

// Flixel
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;

// Using imports
using StringTools;
using util.ArrayTools;
using util.ExtendedStringTools;
using util.CoolUtil;
#end