package sys;

import backend.SongData;
import openfl.utils.Future;
import openfl.Assets;
import openfl.media.Sound;

class Paths
{
    // do NOT make these the same or shit WILL break!
    public static final metadataExtension:String = 'json';
    public static final multiME:String = "mmdf"; // Multi Metadata Format's extension (Json based)
	public static final playlistExt:String = "pl"; // Extension for playlists (Json based)

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
		return FileSystem.readDirectory(songMetadataFolder());

	public static function songPlaylistFolder():String
		return 'assets/data/playlists/';

	public static function playlistFile(key:String):String
    {
		if (!FileSystem.exists(songPlaylistFolder() + '$key.$playlistExt'))
		{
			trace('Shit `${songPlaylistFolder() + '$key.$playlistExt'}` does not exist!', ERROR);
			return null;
		}
		return songPlaylistFolder() + '$key.$playlistExt';
	}

	public static function listPlaylistFiles():Array<String>
		return FileSystem.readDirectory(songPlaylistFolder());

    public static function image(key:String):String
    {
        return 'assets/images/$key.png';
    }

    public static function song(key:String):Sound
    {
		var path:String = 'assets/songs/$key.ogg';
		if (!SongData.songCache.exists(path))
			SongData.songCache.set(path, Sound.fromFile('./assets/songs/$key.ogg'));

		return SongData.songCache.get(path);
	}

	static var cachedSounds:Map<String, Sound> = [];
    public static function sound(key:String):Sound
    {
		var path:String = 'assets/sounds/$key.ogg';
		if (!cachedSounds.exists(path))
			cachedSounds.set(path, Sound.fromFile('./assets/sounds/$key.ogg'));

		return cachedSounds.get(path);
    }
}