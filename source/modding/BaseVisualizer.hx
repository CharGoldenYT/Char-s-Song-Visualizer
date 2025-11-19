package modding;

import data.song.SongHandler;
import flixel.ui.FlxBar;

class BaseVisualizer extends BaseScript
{
    var timeTxt:FlxText;
    var player:FlxSprite;
    var timeBar:FlxBar;
    var songPercent(get, null):Float;

    function get_songPercent():Float return curSong.time / curSong.length;

    public function new()
    {
        super("Base Visualizer - Player With Controls");
    }

    public override function onCreate() {
        super.onCreate();

        player = new FlxSprite().makeGraphic(300, 150, 0xFFCC66DD);
        add(player);
        player.y = FlxG.height - player.height;

        timeTxt = new FlxText(0, 0, FlxG.width, "0:00 : 0:00");
        timeTxt.setFormat(Paths.font("Technology.ttf"), 20, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        timeTxt.y = player.y - (timeTxt.height + 50);
        add(timeTxt);

        timeBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width - 200, 20, this, "songPercent");
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFFFFFFFF, 0xFFFF8800);
		timeBar.numDivisions = 800;
        add(timeBar);
        timeBar.y = timeTxt.y - (timeBar.height + 20);
        timeBar.x = FlxG.width - (timeBar.width + 25);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        timeTxt.text = SongHandler.songTimeText;
    }
}