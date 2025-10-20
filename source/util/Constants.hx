package util;

class Repr_SemVer // move over thx.semver /j
{
	public var major:Int;
	public var minor:Int;
	public var patch:Int;
	public var identifier:String = '';

	public function new(major:Int, minor:Int, patch:Int, ?identifier:String = null)
	{
		this.major = major;
		this.minor = minor;
		this.patch = patch;
		if (identifier != null)
			this.identifier = identifier;
	}

	public function toString():String
	{
		return '$major.$minor.$patch$identifier';
	}

	public static function fromString(s:String, ?identifier:String = null):Repr_SemVer
	{
		var s_semver:Array<String> = s.split(".");
		return new Repr_SemVer(s_semver[0].parseInt(), s_semver[1].parseInt(), s_semver[2].parseInt(), identifier);
	}

	public function copy():Repr_SemVer
		return new Repr_SemVer(major, minor, patch, identifier);
}

class Constants
{
	public static final isUnix:Bool = #if IS_UNIX true #else false #end;
	public static final h:String = #if IS_UNIX Sys.getEnv("HOME") #else '' #end;
    public static final saveFolder:String = "Char_s-Song-Visualizer";
	public static final ver:Repr_SemVer = new Repr_SemVer(0, 0, 1);
	public static final settingFileVersion:Repr_SemVer = new Repr_SemVer(1, 0, 0);
	public static final ufPath:String = h + '/Music/CSV/';
	public static final inDebug:Bool = #if debug true #else false #end;
}