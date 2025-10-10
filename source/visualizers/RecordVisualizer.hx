package visualizers;

import flixel.util.FlxStringUtil;
import states.SongSelector;

class RecordVisualizer extends BaseVisualizer
{
	var playerBG:FlxSprite;
    var songText:FlxText;
    var timeTxt:FlxText;

    public override function create() {
        super.create();

		songText = new FlxText(0, 0, 0, "", 20);
		songText.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		songText.y = playerBG.y + ((playerBG.height * 0.5) - songText.height) - 30;
		add(songText);
		songText.text = '${songData.name}\n${songData.album}\n${ArrayTools.formatArtists(songData.artists)}';
        
        timeTxt = new FlxText(0, 0, 0, "0:00 / " + FlxStringUtil.formatTime(curSong.length / 1000), 20);
		timeTxt.setFormat(null, 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		timeTxt.y = songText.y + 75;
		add(timeTxt);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        timeTxt.text = '${FlxStringUtil.formatTime(curSong.time / 1000)} : ${FlxStringUtil.formatTime(curSong.length / 1000)}';
    }
}