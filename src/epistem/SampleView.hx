package epistem;

import codemirror.CodeMirror;
import js.lib.RegExp;
import codemirror.Autocomplete;
import codemirror.ViewUpdate;
import js.html.Event;
import codemirror.BlockInfo;
import codemirror.EditorView;
import codemirror.EditorState;
import codemirror.CodeMirrorView;
import codemirror.Extension;
import obsidian.Notice;
import obsidian.Menu;
import haxe.extern.EitherType;
import obsidian.WorkspaceLeaf;
import obsidian.View;
import js.lib.Promise;

typedef SampleViewState = { ?count: Int }

class SampleView extends ItemView {

    public static final VIEW_TYPE: String = "sample-view";

    var state: SampleViewState;
    var cmEditor: Null<EditorView>;
    var updateListener: Null<Extension>;
    var completionRegex: RegExp;

    public function new(leaf: WorkspaceLeaf) {
        super(leaf);
        icon = "aperture";
        state = { count: 0 };
        completionRegex = new RegExp("froot");
    }

    override function onPaneMenu(menu: Menu, source: EitherType<PaneMenuSource, String>) {
        super.onPaneMenu(menu, source);
        // trace('onPaneMenu: ${source}');

        switch (source) {
            case PaneMenuSource.MoreOptions:
                menu.addItem(item -> {
                    item.setTitle("Test Item")
                        .setIcon("lamp")
                        .onClick(evt -> {
                            new Notice("More-options: Test Item clicked");
                        });
                });
            case PaneMenuSource.TabHeader:
                menu.addItem(item -> {
                    item.setTitle("Test Item")
                        .setIcon("lamp")
                        .onClick(evt -> {
                            new Notice("Tab-header: Test Item clicked");
                        });
                });
            case PaneMenuSource.SidebarContext:
                menu.addItem(item -> {
                    item.setTitle("Test Item")
                        .setIcon("lamp")
                        .onClick(evt -> {
                            new Notice("Sidebar-context: Test Item clicked");
                        });
                });
        }
    }

    function getDisplayText(): String {
        return "Sample View 🔆";
    }

    function getViewType(): String {
        return SampleView.VIEW_TYPE;
    }

    override function onOpen(): Promise<Void> {
        trace("SampleView opened");
        buildUI();
        addAction("landmark", "Holler", (_) -> {
            final notice = new Notice("Holler !!");
            notice.noticeEl.style.backgroundColor = "yellow";
            state.count = (state.count ?? 0) + 1;
            app.workspace.requestSaveLayout();
            buildUI();
        });

        // trace(CodeMirror);

        return Promise.resolve();
    }

    override function onClose(): Promise<Void> {
        trace("SampleView closed");
        return super.onClose();
    }

    override function getState(): Any {
        // trace('getState --> ${state}');
        return state;
    }

    override function setState(state: Any, result: ViewStateResult): Promise<Void> {
        final incomingState: SampleViewState = cast(state);
        this.state.count = incomingState.count ?? 0;
        // trace('setState --> ${state}');
        buildUI();
        return super.setState(state, result);
    }

    private function handleEditorUpdate(update: ViewUpdate) {
        if (update.selectionSet) {
            final selection = update.view.state.selection.main;
            // trace('Selection: ${selection.from}-${selection.to}');
        }

        update.changes.iterChanges((fromA, toA, fromB, toB, inserted) -> {
            // trace('[$fromA-$toA] [$fromB-$toB] ${inserted.toString()}');
        });
    }

    private function handleCompletions(context: CompletionContext): Null<EitherType<CompletionResult, Promise<Null<CompletionResult>>>> {
        // trace(context.pos);

        final match = context.matchBefore(completionRegex);
        if (match != null) {
            trace("here");
            return {
                from: match.from,
                filter: false,
                options: [
                    { label: "Apple", info: "Foo bar", type: "constant" },
                    { label: "Banana", info: "Bendy Yellow", type: "text" },
                    { label: "Orange", type: "text" }
                ]
            };
        }

        return null;
    }

    function buildUI() {
        // contentEl.innerHTML = "";
        // contentEl.innerHTML = '<p>Hello from SampleView!</p><p>State: ${state.count}</p>';

        if (contentEl.hasChildNodes()) { return; }

        final updateListener = EditorView.updateListener.of(handleEditorUpdate);
        this.updateListener = updateListener;

        final config = new CompletionConfig(true, [handleCompletions], 10, true);
        final completionExtension = Autocomplete.autocompletion(config);

        final fontTheme = EditorView.theme({
            // Apply specifically to the content
            ".cm-content": {
                "fontFamily": "'Source Code Pro', monospace",
                "font-size": "18pt",
                "background-color": "Ivory"
            },
            // You can also target other elements like gutters if needed
            ".cm-gutters": {
                "fontFamily": "'Source Code Pro', monospace",
                "font-size": "15pt"
            }
        });

        cmEditor = new EditorView({
            state: EditorState.create({
                extensions: [
                    CodeMirrorView.lineNumbers({
                        // formatNumber: (lineNo, state) -> { '$lineNo->'; },
                        domEventHandlers: {
                            "click": lineNumberClick
                        }
                    }),
                    fontTheme,
                    updateListener,
                    completionExtension
                ]
            }),
            parent: contentEl
        });
    }

    function lineNumberClick(view: EditorView, line: BlockInfo, event: Event): Bool {
        final lineInfo = view.state.doc.lineAt(line.from);
        new Notice('Clicked line ${lineInfo.number}');
        trace(lineInfo);
        return true;
    }
}