package sys;

import haxe.PosInfos;

class CoolErrorSubstate extends BaseSubState
{
    var back:FlxSprite;
    var text:FlxText;
    var title:FlxText;

    var stateCam:FlxCamera;
    var finishedInit:Bool = false;
    var initDelay:FlxTimer = new FlxTimer(); // make sure you can actually SEE the error.
    var fadeDelay:Int = 2;

    /*
    *   Creates a new substate that shows an error with a title.
    *
    *   @param backRef The FlxSprite to use as the backdrop.
    *   @param fadeDelay How many seconds should the fade be delayed by
    *   @param infos Don't touch this unless you know how `haxe.PosInfos` works.
    */
    public function new(errMsg:String, errTitle:String = "", ?backRef:FlxSprite = null, fadeDelay:Int = 2, ?doTrace:Bool = true, ?infos:PosInfos)
    {
        this.fadeDelay = fadeDelay;
        if (backRef != null)
        {
            back = backRef;
            back.setGraphicSize(FlxG.width, FlxG.height);
            back.updateHitbox();
        }
        else
        {
            back = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        }
        back.alpha = 0.6;

        text = new FlxText(0, 0, FlxG.width, haxe.Log.formatOutput(errMsg, infos));
        text.setFormat(Paths.font('funkin.ttf'), 15, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        text.screenCenter(Y);

        title = new FlxText(0, 100, FlxG.width, errTitle);
        title.setFormat(Paths.font('funkin.ttf'), 50, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);

        if (errTitle.length > 0)
            errTitle += ' - ';

        if (doTrace) Logs.traceNew(errTitle + errMsg, ERROR, infos);

        super();
    }

    var errTween:FlxTween;
    public override function create() {
        super.create();

        stateCam = new FlxCamera();
        stateCam.bgColor.alpha = 0;
        FlxG.cameras.add(stateCam, false);

        add(back);
        add(text);
        add(title);
        
        this.cameras = [stateCam];
        initDelay.start(0.2, function(tmr:FlxTimer){
            finishedInit = true;
        });

        errTween = FlxTween.tween(stateCam, {alpha: 0}, 5, {onComplete: function(twn:FlxTween) close(), startDelay: fadeDelay});
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.anyKeyPressed) close();
    }

    public override function close() {
        super.close();

        if (errTween != null) errTween.cancel();
        FlxG.cameras.remove(stateCam);
    }
}