package epistem;

import obsidian.*;
import js.html.HtmlElement;
import js.html.MouseEvent;
import js.lib.Promise;
import js.lib.Object;

typedef Settings = {
    var mySetting: String;
}

@:expose("default")
class TestPlugin extends Plugin {
    var statusBarElement: Null<HtmlElement>;
    var ribbonClickCount: Int;
    public var settings: Settings;

	public function new(app: App, manifest: PluginManifest) {
		super(app, manifest);
        ribbonClickCount = 0;
        settings = { mySetting: "default" };
	}

    public function onload(): Promise<Void> {
        trace("Plugin loaded");
        registerEditorSuggest(new SampleSuggester(this));
        addRibbonIcon("hand-metal", manifest.name, handleRibbonClick);
        registerMarkdownCodeBlockProcessor("csv", processCSVBlock);
        setUpStatusBar();
        addCommand({id: "simple-command", name: "Simple Command", callback: simpleCommand});
        addCommand({id: "simple-edit-command", name: "Simple Edit Command", editorCallback: simpleEditorCommand});
        addSettingTab(new SampleSettingTab(app, this));

        return loadSettings();
    }

    public function onunload(): Void {
        trace("Plugin unloaded");
    }

    function loadSettings(): Promise<Void> {
        return loadData().then((data) -> {
            Object.assign(settings, data);
        });
    }

    public function saveSettings(): Promise<Void> {
        return saveData(settings);
    }

    function simpleCommand() {
        new SampleModal(this.app).open();
    }

    function simpleEditorCommand(editor: Editor, view: MarkdownView) {
        editor.replaceSelection("Hello from Haxe!");
    }

    function setUpStatusBar() {
        statusBarElement = addStatusBarItem();
        statusBarElement?.innerText = "❇️ Click Me";
        statusBarElement?.addEventListener("click", (e: MouseEvent) -> new Notice("Clicked"));
    }

    function handleRibbonClick(e: MouseEvent) {
        trace("Ribbon icon clicked");
        ribbonClickCount++;
        statusBarElement?.innerText = '💚 Clicked ${ribbonClickCount}';
        new Notice("Haxe Hello World!", 3000);
    }

    function processCSVBlock(source: String, el: HtmlElement, ctx: MarkdownPostProcessorContext): Promise<Void> {
        final rows = source.split("\n").filter((row) -> row.length > 0);
        final doc = el.ownerDocument;
        final table = doc.createTableElement(); el.appendChild(table);

        for (row in rows) {
            final cols = row.split(",");
            final rowEl = doc.createTableRowElement(); table.appendChild(rowEl);

            for (col in cols) {
                final colEl = doc.createTableCellElement(); rowEl.appendChild(colEl);
                colEl.innerText = col;

                colEl.addEventListener("click", (e) -> {
                    e.srcElement.style.backgroundColor = "#ffff00";
                    new Notice("You clicked on: " + col, 2000);
                });
            }
        }

        return Promise.resolve();
    }
}

// TODO: Add Any instead of dynamic
// TODO: Add a markdown post processor example
// TODO: Add file system access example
// TODO: Add timer interval example
// TODO: Add DOM event handler example
// TODO: Add code block that renders an image
// TODO: Canvas plugin example
