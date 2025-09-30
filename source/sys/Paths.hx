package sys;

import openfl.Assets;
import openfl.media.Sound;

class Paths
{
    // do NOT make these the same or shit WILL break!
    public static final metadataExtension:String = 'json';
    public static final multiME:String = "mmdf"; // Multi Metadata Format's extension (Json based)

    public static function songMetadataFolder():String return "assets/data/songMetadata/";
    public static function songMetadata(key:String):String
    {
        if (!FileSystem.exists(songMetadataFolder() + '$key.$metadataExtension'))
        {
            trace('Shit `${songMetadataFolder() + '$key.$metadataExtension'}` does not exist!', ERROR);
            return null;
        }

        return songMetadataFolder() + '$key.$metadataExtension';
    }

    public static function multiSongData(key:String):String
    {
        if (!FileSystem.exists(songMetadataFolder() + '$key.$multiME'))
        {
            trace('Shit `${songMetadataFolder() + '$key.$multiME'}` does not exist!', ERROR);
            return null;
        }

        return songMetadataFolder() + '$key.$multiME';
    }

    public static function listMetadataFiles():Array<String>
    {
        return FileSystem.readDirectory(songMetadataFolder());
    }

    public static function image(key:String):String
    {
        return 'assets/images/$key.png';
    }

    public static function song(key:String):Sound
    {
        return Assets.getSound('assets/songs/$key.ogg');
    }

    public static function sound(key:String):Sound
    {
        return Assets.getSound('assets/sounds/$key.ogg');
    }
}