package epistem;

import codemirror.EditorView;
import codemirror.EditorState;
import codemirror.CodeMirrorView;
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

    public function new(leaf: WorkspaceLeaf) {
        super(leaf);
        icon = "aperture";
        state = { count: 0 };
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

    function buildUI() {
        // contentEl.innerHTML = "";
        // contentEl.innerHTML = '<p>Hello from SampleView!</p><p>State: ${state.count}</p>';

        if (contentEl.hasChildNodes()) { return; }

        cmEditor = new EditorView({
            state: EditorState.create({
                extensions: [ CodeMirrorView.lineNumbers() ]
            }),
            parent: contentEl
        });
    }
}