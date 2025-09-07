package obsidian;

import js.html.MouseEvent;
import js.html.Element;
import js.lib.Promise;
import haxe.extern.EitherType;

typedef ViewState = {
    var type: String;
    var ?state: Any;
    var ?active: Bool;
    var ?pinned: Bool;
    var ?group: WorkspaceLeaf;
}

typedef OpenViewState = {
    var ?state: Any;
    var ?eState: Any;
    var ?active: Bool;
    var ?group: WorkspaceLeaf;
}

typedef ViewStateResult = {
    /** Set this to true to indicate that there is a state change which should be recorded in the navigation history. */
    history: Bool
}

@:jsRequire("obsidian", "ItemView")
extern abstract class ItemView extends View {

    final contentEl: Element;

    function new(leaf: WorkspaceLeaf);

    function addAction(icon: String, title: String, callback: (evt: MouseEvent) -> Void): Element;
}


@:jsRequire("obsidian", "View")
extern abstract class View extends Component {
    final app: App;
    var icon: String;

    /**
     * Whether or not the view is intended for navigation.
     * If your view is a static view that is not intended to be navigated away, set this to false.
     * (For example: File explorer, calendar, etc.)
     * If your view opens a file or can be otherwise navigated, set this to true.
     * (For example: Markdown editor view, Kanban view, PDF view, etc.)
     */
    var navigation: Bool;

    final leaf: WorkspaceLeaf;
    final containerEl: Element;

    function new(leaf: WorkspaceLeaf);

    function onOpen(): Promise<Void>;  // can be overridden
    function onClose(): Promise<Void>; // can be overridden
    abstract function getViewType(): String;

    function getState(): Any;
    function setState(state: Any, result: ViewStateResult): Promise<Void>;
    function getEphemeralState(): Any;
    function setEphemeralState(state: Any): Void;
    function getIcon(): String;
    function onResize(): Void;
    abstract function getDisplayText(): String;

    /**
     * Populates the pane menu.
     *
     * (Replaces the previously removed `onHeaderMenu` and `onMoreOptionsMenu`)
     */
    function onPaneMenu(menu: Menu, source: EitherType<PaneMenuSource, String>): Void;
}

enum abstract PaneMenuSource(String) {
    var MoreOptions = 'more-options';
    var TabHeader = 'tab-header';
}
