package epistem;

import obsidian.Notice;
import obsidian.Plugin;
import js.lib.Promise;

@:expose("default")
class TestPlugin extends Plugin {
    public function onload(): Promise<Void> {
        trace("Plugin loaded");
        this.addRibbonIcon("hand-metal", "Haxe Test Plugin", function(evt) {
            trace("Ribbon icon clicked");
            new Notice("Haxe Hello World!", 3000);
        });

        this.registerMarkdownCodeBlockProcessor("csv", (source, el, ctx) -> {
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
                        e.srcElement.style.backgroundColor = "#ffcccc";
                        new Notice("You clicked on: " + col, 2000);
                    });
                }
            }

            return Promise.resolve();
		});
        
        return loadSettings();
    }

    public function onunload(): Void {
        trace("Plugin unloaded");
    }

    function loadSettings(): Promise<Void> {
        return this.loadData().then((_) -> {});
    }
}

// TODO: Add settings save/load and a settings tab UI
// TODO: Add a markdown post processor example
// TODO: Add a command example
// TODO: Add suggestion handler
// TODO: Add status bar item example
// TODO: Add modal dialog example
// TODO: Add file system access example
// TODO: Add timer interval example
// TODO: Add DOM event handler example
