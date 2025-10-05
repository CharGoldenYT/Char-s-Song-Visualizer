package backend;

class Repr_SemVer // move over thx.semver /j
{
	public var major:Int;
	public var minor:Int;
	public var patch:Int;
	public var identifier:String = null;

	public function new(major:Int, minor:Int, patch:Int, ?identifier:String = null)
	{
		this.major = major;
		this.minor = minor;
		this.patch = patch;
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
    public static final saveFolder:String = "Char_s-Song-Visualizer";
	public static final ver:Repr_SemVer = new Repr_SemVer(0, 0, 1);
}