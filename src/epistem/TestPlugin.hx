package epistem;

import js.lib.WebAssembly;
import haxe.extern.EitherType;
import obsidian.Workspace.EventName_EditorMenu;
import obsidian.Files.TAbstractFile;
import obsidian.*;
import js.html.Element;
import js.html.MouseEvent;
import js.lib.Promise;
import js.lib.Object;
using StringTools;

typedef Settings = {
    var mySetting: String;
}

@:expose("default")
class TestPlugin extends Plugin {
    var statusBarElement: Null<Element>;
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
        addCommand({id: "wasm-command", name: "Test WASM", callback: testWasm});
        addCommand({id: "open-view-command", name: "Open Sample View", callback: openViewCommand});
        addCommand({id: "simple-edit-command", name: "Simple Edit Command", editorCallback: simpleEditorCommand});
        addSettingTab(new SampleSettingTab(app, this));
        registerEvent(app.vault.on(Modify, handleFileChange));
        registerView(SampleView.VIEW_TYPE, (leaf) -> new SampleView(leaf));
        registerEvent(app.workspace.on(EditorMenu, editMenuOpen));

        final testTxtPath = Obsidian.normalizePath('${app.vault.configDir}/plugins/haxe-test-plugin/test.txt');
        app.vault.adapter.read(testTxtPath).then((content) -> {
            trace('CONTENT:\n${content}');
        });

        return loadSettings();
    }

    public function onunload(): Void {
        trace("Plugin unloaded");
    }

    function editMenuOpen(menu: Menu, editor: Editor, info: EitherType<MarkdownView, MarkdownFileInfo>) {
        menu.addItem(item -> {
            item.setTitle("Test Item")
                .setIcon("pentagon")
                .onClick(evt -> {
                    new Notice("Test Item clicked");
                });
        });
    }

    function loadSettings(): Promise<Void> {
        return loadData().then((data) -> {
            Object.assign(settings, data);
        });
    }

    public function saveSettings(): Promise<Void> {
        return saveData(settings);
    }

    function handleFileChange(file: TAbstractFile): Void {
        trace('File changed: ${file.path}');
    }

    function simpleCommand() {
        final activeFile = app.workspace.getActiveFile();
        if (activeFile != null) {
            final cache = app.metadataCache.getFileCache(activeFile);
            final blocks = cache?.blocks;
            if (blocks != null) {
                for (key=>value in blocks) {
                    trace('block ${key} => ${value}');
                }
            }

            final embeds = cache?.embeds;
            if (embeds != null) {
                for(embed in embeds) {
                    trace('Embed: $embed');
                }
            }
        }

        new SampleModal(this.app).open();
    }

    function testWasm() {
        final wasmPath = Obsidian.normalizePath('${app.vault.configDir}/plugins/haxe-test-plugin/hello_world.wasm');
        app.vault.adapter.readBinary(wasmPath).then(buffer -> {
            final imports = {
                env: { abort: () -> trace("Abort!") }
            };
            WebAssembly.instantiate(buffer, imports).then(wasmModule -> {
                final addResult = wasmModule.instance.exports.add(24, 5);
                trace('WASM result = ${addResult}');
            });
        });
    }

    function openViewCommand() {
        final leaves = app.workspace.getLeavesOfType(SampleView.VIEW_TYPE);
        if (leaves.length > 0) {
            app.workspace.revealLeaf(leaves[0]);
        } else {
            final leaf = app.workspace.getRightLeaf(false);
            leaf.setViewState({ type: SampleView.VIEW_TYPE, active: true })
                .then((_) -> app.workspace.revealLeaf(leaf));
        }
    }

    function simpleEditorCommand(editor: Editor, view: MarkdownView) {
        final files = app.vault.getAllLoadedFiles();
        var cursor = editor.getCursor();
        for (file in files) {
            editor.replaceRange("\n- " + file.name + " " + file.path, cursor);
        }
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

    function processCSVBlock(source: String, el: Element, ctx: MarkdownPostProcessorContext): Promise<Void> {
        final rows = source.split("\n").filter((row) -> row.length > 0);
        final doc = el.ownerDocument;
        final table = doc.createTableElement(); el.appendChild(table);

        for (row in rows) {
            final cols = row.split(",");
            final rowEl = doc.createTableRowElement(); table.appendChild(rowEl);

            for (col in cols) {
                final colEl = doc.createTableCellElement(); rowEl.appendChild(colEl);
                col = col.ltrim();

                if (col.indexOf("!") == 0) {
                    final iconId = col.substr(1);
                    final icon = Obsidian.getIcon(iconId);
                    if (icon != null) {
                        colEl.appendChild(icon);
                        Obsidian.setTooltip(colEl, "Icon: " + iconId);
                    } else {
                        colEl.innerText = "Icon not found: " + iconId;
                    }
                } else {
                    colEl.innerText = col;
                }

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
// TODO: Protocol handler example
// TODO: CodeMirror editor extension example
// TODO: MarkdownView
