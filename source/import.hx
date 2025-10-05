#if !macro
// Backend shit
import backend.BaseState;
import backend.BaseSubState;
import backend.Constants;
import sys.LuaIterator;
import sys.logger.Logs;
import sys.logger.Logs.traceNew as tracen;
import sys.logger.Level;
import sys.Paths;
import backend.Discord;

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

// Using imports
using StringTools;
using backend.ArrayTools;
using backend.ExtendedStringTools;
using backend.CoolUtil;
#end