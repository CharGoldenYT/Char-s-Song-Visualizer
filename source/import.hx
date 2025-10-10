#if !macro
// Project shit
//
// backend
import states.BaseState;
import substates.BaseSubState;
import backend.util.Constants;
import backend.Discord;
//
// sys
import sys.LuaIterator;
import sys.logger.Logs;
import sys.logger.Logs.traceNew as tracen;
import sys.logger.Level;
import sys.Paths;
import sys.CoolErrorSubstate;
import sys.Controls;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end

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
import flixel.math.FlxPoint;

// Using imports
using StringTools;
using backend.util.ArrayTools;
using backend.util.ExtendedStringTools;
using backend.util.CoolUtil;
#end