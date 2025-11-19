package substates;

import modding.BaseVisualizer;
import states.SongSelectionState;
import modding.BaseScript;

class VisualizerSubstate extends BaseSubState
{
    static var curScript:BaseScript;
    public static var instance:VisualizerSubstate;
    var bg:FlxSprite;

    public override function create() {
        super.create();

        this.cameras = [SongSelectionState.instance.camViz];
        bg = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
        bg.alpha = 0.5;
        add(bg);

        instance = this;

        getVisualizer();

        curScript.onCreatePost();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        //curScript.update(elapsed);
        curScript.onUpdatePost(elapsed);
    }

    function getVisualizer()
    {
        // Script checking code here
        curScript = new BaseVisualizer();
        curScript.onCreate();
    }
}