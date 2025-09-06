package obsidian;

import js.lib.Promise;
import js.html.HtmlElement;
import js.html.MouseEvent;

@:jsRequire("obsidian", "Plugin")
extern abstract class Plugin extends Component {

    final app: App;
    final manifest: PluginManifest;

    function new(app: App, manifest: PluginManifest);

    abstract function onload(): Promise<Void>;
    abstract function onunload(): Void;

    final function loadData(): Promise<Any>;
    final function saveData(data: Dynamic): Promise<Void>;

    /**
     * Register a special post processor that handles fenced code given a language and a handler.
     * This special post processor takes care of removing the <pre><code> and create a <div> that
     * will be passed to the handler, and is expected to be filled with custom elements.
     */
    function registerMarkdownCodeBlockProcessor(
        language: String,
        handler: (source: String, el: HtmlElement, ctx: MarkdownPostProcessorContext) -> Promise<Void>,
        ?sortOrder: Float): MarkdownPostProcessor;

    function addRibbonIcon(icon: String, title: String, callback: (evt: MouseEvent) -> Void): HtmlElement;

    /**
     * Adds a status bar item to the bottom of the app.
     * Not available on mobile.
     */
    function addStatusBarItem(): HtmlElement;

    /**
     * Register a command globally.
     * Registered commands will be available from the @{link https://help.obsidian.md/Plugins/Command+palette Command pallete}.
     * The command id and name will be automatically prefixed with this plugin's id and name.
     */
    function addCommand(command: Command): Command;

    /**
     * Register a settings tab, which allows users to change settings.
     * @see {@link https://docs.obsidian.md/Plugins/User+interface/Settings#Register+a+settings+tab}
     */
    function addSettingTab(settingTab: PluginSettingTab): Void;

    /**
     * Register an EditorSuggest which can provide live suggestions while the user is typing.
     */
    function registerEditorSuggest(editorSuggest: EditorSuggest<Any>): Void;

    function registerView(type: String, viewCreator: (leaf: WorkspaceLeaf) -> View): Void;
}
