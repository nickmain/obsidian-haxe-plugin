package epistem;

import obsidian.*;
import js.html.HtmlElement;
import js.html.MouseEvent;
import js.lib.Promise;

@:expose("default")
class TestPlugin extends Plugin {
    var statusBarElement: Null<HtmlElement>;
    var ribbonClickCount: Int;

	public function new(app: App, manifest: PluginManifest) {
		super(app, manifest);
        ribbonClickCount = 0;
	}

    public function onload(): Promise<Void> {
        trace("Plugin loaded");
        addRibbonIcon("hand-metal", manifest.name, handleRibbonClick);
        registerMarkdownCodeBlockProcessor("csv", processCSVBlock);
        setUpStatusBar();
        addCommand({id: "simple-command", name: "Simple Command", callback: simpleCommand});

        return loadSettings();
    }

    public function onunload(): Void {
        trace("Plugin unloaded");
    }

    function loadSettings(): Promise<Void> {
        return loadData().then((_) -> {});
    }

    function simpleCommand() {
        new Notice("Simple Command Executed", 2000);
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

// TODO: HTMLElement instead of HtmlElement where applicable
// TODO: Add Any instead of dynamic
// TODO: Add settings save/load and a settings tab UI
// TODO: Add a markdown post processor example
// TODO: Add an editor command example
// TODO: Add suggestion handler
// TODO: Add status bar item example
// TODO: Add modal dialog example
// TODO: Add file system access example
// TODO: Add timer interval example
// TODO: Add DOM event handler example
// TODO: Add code block that renders an image
