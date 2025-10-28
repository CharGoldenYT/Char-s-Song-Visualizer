package sys;

import data.SongData;
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
		var path = "assets/" + fPrefix + key;
		var path2 = "./externSongs/" + pFix + key;
		var path3 = Constants.ufPath + 'externSongs/' + pFix + key; // Music folder.
		if (exists(path3))
			return path3;
		else if (exists(path2))
			return path2;
		else
			return path;
	}

	public static function getPathArray(key:String, fPrefix:String = "", pfixfextsongs:Bool = true):Array<String>
	{
		var pFix:String = pfixfextsongs ? fPrefix : '';
		var path = "assets/" + fPrefix + key;
		var path2 = "externSongs/" + pFix + key;
		var path3 = Constants.ufPath + 'externSongs/' + pFix + key; // Music Folder

		var fPath:Array<String> = [];
		if (exists(path3))
			fPath = path3.split("/");
		else if (exists(path2))
			fPath = path2.split("/");
		else
			fPath = path.split("/");

		if (fPath[0] == '')
		{
			if (fPath[1] == "Users")
			{
				fPath.splice(0, 4);
			}
			else
			{
				fPath.splice(0, 1);
			}
		}

		return fPath;
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

		if (Constants.isUnix)
		{
			for (file in FileSystem.readDirectory(Constants.ufPath + 'externSongs/'))
			{
				if (file.endsWith(multiME) || file.endsWith(metadataExtension))
					list.pushUnique(file);
			}
		}

		return list;
	}

	/*
	 * I'M GOING TO
	**/
	public static function songPlaylistFolder(key:String):String
	{
		var path = "assets/data/playlists/" + key;
		var path2 = "./playlists/" + key;
		var path3 = Constants.ufPath + 'playlists/' + key; // Mac/Linux music folder.

		if (exists(path3) && Constants.isUnix)
			return path3;
		else if (exists(path2))
			return path2;
		else
			return path;
	}

	public static function getPlaylistPathArray(key:String):Array<String>
	{
		var path = "assets/data/playlists/" + key;
		var path2 = "./playlists/" + key;
		var path3 = Constants.ufPath + 'playlists/' + key; // Mac/Linux music folder.

		var fPath:Array<String> = [];
		if (exists(path3) && Constants.isUnix)
			fPath = path3.split("/");
		else if (exists(path2))
			fPath = path2.split("/");
		else
			fPath = path.split("/");

		if (fPath[0] == '')
		{
			if (fPath[1] == "Users")
			{
				fPath.splice(0, 4);
			}
			else
			{
				fPath.splice(0, 1);
			}
		}

		return fPath;
	}	

	public static function playlistFile(key:String):String
    {
		if (!FileSystem.exists(songPlaylistFolder('$key.$playlistExt')))
		{
			tracen('Shit `${songPlaylistFolder('$key.$playlistExt')}` does not exist!', ERROR);
			return null;
		}
		return songPlaylistFolder('$key.$playlistExt');
	}

	public static inline function mkdir(fPath:String)
	{
		if (!FileSystem.exists(fPath))
			FileSystem.createDirectory(fPath);
	}

	public static function listPlaylistFiles():Array<String>
	{
		var a:Array<String> = [];
		for (file in FileSystem.readDirectory("assets/data/playlists"))
		{
			if (file.endsWith(playlistExt))
				a.pushUnique(file);
		}

		for (file in FileSystem.readDirectory("playlists/"))
		{
			if (file.endsWith(playlistExt))
				a.pushUnique(file);
		}

		for (file in FileSystem.readDirectory(Constants.ufPath + "playlists"))
		{
			if (file.endsWith(playlistExt))
				a.pushUnique(file);
		}

		return a;
	}

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
	public static function font(key:String):String
	{
		return 'assets/fonts/$key';
	}
}