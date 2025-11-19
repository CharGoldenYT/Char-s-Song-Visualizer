package states;

import openfl.system.System;
import util.ObjectGroup;
import objects.CreditObject;

typedef Credit = {
    var name:String;
    @:optional var desc:String;
    @:optional var icon:String;
    @:optional var bgColor:FlxColor;
    @:optional var link:String;
}

class CreditState extends BaseState
{
    var bg:FlxSprite;
    var camBG:FlxCamera;
    var camCredits:FlxCamera;
    var camFollow:FlxObject;

    var descBox:FlxSprite;
    var descText:FlxText;
    var camDesc:FlxCamera;

    var curSelected:Int = 0;
    var grpCredits:ObjectGroup<CreditObject>;
    var intendedColor:FlxColor = 0xFFFFFFFF;

    var creditList:Array<Credit> = [
        { name: "People who worked on the app" },
        {
            name: "Char (CharGoldenYT)",
            desc: "Creator, Lead Coder, and Artist",
            icon: "char",
            bgColor: 0xFFFF8800,
            link: "https://vschar-official.com"
        },
        {
            name: "VideoBotYT",
            desc: "Project Advisor essentially, made the original concept for the Player UI",
            icon: "videobot",
            bgColor: 0xFF14FFFF,
            link: "https://linktr.ee/videobot"
        },
        { name: "Special Thanks" },
        {
			name: 'Daveberry',
			icon: 'dave',
			desc: 'Tested the Linux build of Char\'s Song Visualizers',
			link: 'https://daveberry.netlify.app/',
			bgColor: 0xFF008BFF
        },
        { name: "People you should check out" },
        {
            name: "CosmiChaos1129",
            icon: "cosmi",
            desc: "Cool cat that does cool arts!",
            link: "https://ko-fi.com/cosmichaos1129/commissions",
            bgColor: 0xFF9446CF
        }
    ];

    public override function create() {
        super.create();

        camFollow = new FlxObject();
        camFollow.x = 100;
        camBG = newCam(0,0,0,0,0,0xFF000000, 1, true);
        camCredits = newCam(0,0,0,0,0,0xFF000000, 0, false, camFollow);
        camDesc = newCam();
        camDesc.bgColor.alpha = 0;

        bg = new FlxSprite().loadGraphic(Paths.image("DesatBG"));
        bg.antialiasing = true;
        add(bg);
    
        grpCredits = new ObjectGroup<CreditObject>();
        add(grpCredits);
        grpCredits.cameras = [camCredits];

        descBox = new FlxSprite().makeGraphic(1100, 200, 0xFF000000);
        descBox.alpha = 0.5;
        descBox.cameras = [camDesc];
        add(descBox);
        descBox.screenCenter(X);
        descBox.y = FlxG.height - (descBox.height + 25);

        descText = new FlxText(0, 0, descBox.width - 10, "");
        descText.setFormat(Paths.font("UbuntuMB.ttf"), 40, 0xFFFFFFFF);
        descText.cameras = [camDesc];
        descText.x = descBox.x + 5;
        descText.y = descBox.y;
        add(descText);

        for (i in 0...creditList.length)
        {
            var credit = creditList[i];
            if (creditList[i].bgColor == null) creditList[i].bgColor = 0xFFFFFFFF;
            var obj:CreditObject = new CreditObject(0, 75 * i, credit.name, credit.desc, credit.icon, credit.link, credit.bgColor);
            grpCredits.add(obj);
        }

        changeSelection();
    }

    var colorTween:FlxTween;
    public function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected >= creditList.length)
        {
            curSelected = 0;
        }
        if (curSelected < 0)
        {
            curSelected = creditList.length - 1;
        }
        
        grpCredits.forEachIndexed((member, i)->{
            if (i == curSelected)
            {
                member.alpha = 1;
                camFollow.y = member.y;
                intendedColor = member.bgColor;

                if (colorTween != null) colorTween.cancel();
                colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {ease:FlxEase.linear});

                descText.text = member.desc;
                descBox.visible = (member.desc != null);
                if (member.desc != null)
                {
                    if (member.desc.length <= 15)
                    {
                        descText.size = 80;
                    }
                    else
                    {
                        descText.size = 40;
                    }
                }
            }
            else
            {
                member.alpha = 0.6;
            }
        });
    }

    function selectable(o:Credit):Bool
    {
        return (o.link != null);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.DOWN_P)
        {
            changeSelection(1);
        }
        if (controls.UP_P)
        {
            changeSelection(-1);
        }
        if (controls.BACK)
        {
            FlxG.switchState(new SongSelectionState());
        }

        if (controls.CONFIRM && selectable(creditList[curSelected]))
        {
            var credit = creditList[curSelected];
            openURL(credit.link);
        }
    }

    function openURL(link:String)
    {
        #if desktop
            lime.system.System.openURL(link);
        #else
            tracen("Well you're shit outta luck bub.", ERROR);
        #end
    }
}