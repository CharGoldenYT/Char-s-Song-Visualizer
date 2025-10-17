package data;

import flixel.util.FlxSave;
import util.settings.VisualizerConfig;
import util.settings.AppConfig;

class SettingsHandler
{
    public static var config:AppConfig = null;
    public static var visualizerConfig:VisualizerConfig = null;

    public static function saveConfig()
    {
        var save:FlxSave = new FlxSave();
        save.bind("CSV_AppConfig-" + Constants.settingFileVersion.toString(), Constants.saveFolder);
        for (setting in Reflect.fields(config))
        {
            Reflect.setField(save.data, setting, Reflect.field(config, setting));
        }
        for (setting in Reflect.fields(visualizerConfig))
        {
            Reflect.setField(save.data, setting, Reflect.field(visualizerConfig, setting));
        }
    }

    public static function loadConfig()
    {
        if (config == null) config = new AppConfig();
        if (visualizerConfig == null) visualizerConfig = new VisualizerConfig();
        var save:FlxSave = new FlxSave();
        save.bind("CSV_AppConfig-" + Constants.settingFileVersion.toString(), Constants.saveFolder);

        for (setting in Reflect.fields(save.data))
        {
            if (Reflect.hasField(config, setting)) Reflect.setField(config, setting, Reflect.field(save.data, setting));
            if (Reflect.hasField(visualizerConfig, setting)) Reflect.setField(visualizerConfig, setting, Reflect.field(save.data, setting));
        }
    }
}