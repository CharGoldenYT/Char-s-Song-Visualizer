package objects;

import flixel.util.FlxColor;

class CreditObject extends FlxSpriteGroup
{
    public var name:String = '';
    public var desc:Null<String>;
    public var icon:Null<String>;
    public var link:Null<String>;
    public var bgColor:Null<FlxColor>;

    public function new(x:Float, y:Float, name:String, desc:Null<String> = null, icon:Null<String> = null, link:Null<String> = null, bgColor:Null<FlxColor> = null)
    {
        super(x, y);

        this.name = name;
        this.desc = desc;
        this.icon = icon;
        this.bgColor = bgColor;
        this.icon = icon;
        this.link = link;

        updateCredit();
    }

    public var iconSprite:FlxSprite;
    public var creditName:FlxText;

    public function updateCredit():CreditObject
    {
        if (iconSprite == null)
        {
            iconSprite = new FlxSprite();
            add(iconSprite);
        }
        if (creditName == null)
        {
            creditName = new FlxText(0, 0, 0, name);
            if (link != null)
                creditName.setFormat(Paths.font("UbuntuMB.ttf"), 30, 0xFF000000, LEFT, OUTLINE, 0xFFFFFFFF);
            else
                creditName.setFormat(Paths.font("UbuntuMB.ttf"), 30, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
            add(creditName);
        }

        creditName.text = name;

        if (icon != null)
        {
            creditName.x = 70;
            iconSprite.loadGraphic(Paths.image('credits/$icon'));
            iconSprite.visible = true;
            iconSprite.setGraphicSize(65);
            iconSprite.updateHitbox();
            iconSprite.y = creditName.y - 10;
        }
        else
        {
            creditName.x = 0;
            iconSprite.visible = false;
        }
        creditName.antialiasing = true;
        iconSprite.antialiasing = true;

        return this;
    }
}