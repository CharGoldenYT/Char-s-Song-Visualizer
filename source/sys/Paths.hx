package sys;

import backend.SongData;
import openfl.media.Sound;

class Paths
{
    // do NOT make these the same or shit WILL break!
    public static final metadataExtension:String = 'json';
	/**
	 * Multi Metadata Format's extension (Json based)
	 */
	public static final multiME:String = "mmdf";

	/**
	 * Extension for playlists (Json based)
	 */
	public static final playlistExt:String = "pl";

	public static function exists(path:String):Bool
	{
		return FileSystem.exists(path);
	}

	/**
	 * Gets whether a file is in externSongs or is in assets. NOTE: `externSongs` takes priority
	 * @param key File
	 * @param fPrefix Folder's Prefix (In assets)
	 * @param pfixfextsongs Allow externSongs to also have the prefix.
	 * @return String
	 */
	public static function getPath(key:String, fPrefix:String = "", pfixfextsongs:Bool = true):String
	{
		var pFix:String = pfixfextsongs ? fPrefix : '';
		var path1 = "./externSongs/" + pFix + key;
		var path2 = "assets/" + fPrefix + key;
		if (exists(path1))
			return path1;
		else
			return path2;
	}

    public static function songMetadata(key:String):String
    {
		var path:String = getPath('$key.$metadataExtension');
		if (exists(path))
        {
			return path;
		}

		tracen('`$key.$metadataExtension does not exist in songMetadata!', ERROR);
		return null;
	}

    public static function multiSongData(key:String):String
    {
		var path:String = getPath('$key.$multiME', "data/songMetadata/", false);
		if (exists(path))
        {
			return path;
		}

		tracen('`$key.$multiME does not exist in songMetadata!', ERROR);
		return null;
	}
	public static function listMetadataFiles():Array<String>
	{
		var list:Array<String> = [];

		for (file in FileSystem.readDirectory("assets/data/songMetadata"))
			list.pushUnique(file);

		for (file in FileSystem.readDirectory('externSongs/'))
		{
			if (file.endsWith(multiME) || file.endsWith(metadataExtension))
				list.pushUnique(file);
		}

		return list;
	}

	public static function songPlaylistFolder():String
		return 'assets/data/playlists/';

	public static function playlistFile(key:String):String
    {
		if (!FileSystem.exists(songPlaylistFolder() + '$key.$playlistExt'))
		{
			tracen('Shit `${songPlaylistFolder() + '$key.$playlistExt'}` does not exist!', ERROR);
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
		var path:String = getPath('$key.ogg', 'songs/', false);
		if (!SongData.songCache.exists(path))
			SongData.songCache.set(path, Sound.fromFile(path));

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