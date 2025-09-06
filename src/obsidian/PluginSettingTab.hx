package obsidian;

import js.html.Element;

@:jsRequire("obsidian", "SettingTab")
extern abstract class SettingTab {
    final app: App;
    final containerEl: Element;
    abstract function display(): Void;
    function hide(): Any;
}

@:jsRequire("obsidian", "PluginSettingTab")
extern abstract class PluginSettingTab extends SettingTab {
    function new(app: App, plugin: Plugin);
}
