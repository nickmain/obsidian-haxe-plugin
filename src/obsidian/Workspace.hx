package obsidian;

import haxe.extern.EitherType;
import js.html.HtmlElement;
import js.html.Window;
import js.html.DragEvent;
import js.html.ClipboardEvent;
import js.lib.Promise;
import obsidian.Files.TFile;
import obsidian.Files.TAbstractFile;
import obsidian.Events.EventRef;
import obsidian.WorkspaceLeaf.WorkspaceWindow;
import obsidian.WorkspaceLeaf.WorkspaceParent;
import obsidian.WorkspaceLeaf.WorkspaceSplit;
import obsidian.WorkspaceLeaf.WorkspaceSidedock;
import obsidian.WorkspaceLeaf.WorkspaceRoot;
import obsidian.View.OpenViewState;

enum abstract SplitDirection(String) { var Vertical = 'vertical'; var Horizontal = 'horizontal'; }
enum abstract PaneType(String) { var Tab = 'tab'; var Window = 'window'; }
enum abstract SplitPanelType(String) { var Split = 'split'; }
extern class WorkspaceRibbon {}

extern class WorkspaceMobileDrawer extends WorkspaceParent {
    final collapsed: Bool;
    function expand(): Void;
    function collapse(): Void;
    function toggle(): Void;
}

typedef WorkspaceWindowInitData = {
    /** The suggested size */
    var ?size: { width: Float, height: Float };
}

extern class Tasks {
    function add(callback: () -> Promise<Void>): Void;
    function addPromise(promise: Promise<Void>): Void;
    function isEmpty(): Bool;
    function promise(): Promise<Void>;
}

extern class Workspace extends Events {

    final leftSplit: EitherType<WorkspaceSidedock, WorkspaceMobileDrawer>;
    final rightSplit: EitherType<WorkspaceSidedock, WorkspaceMobileDrawer>;
    final leftRibbon: WorkspaceRibbon;
    final rightRibbon: WorkspaceRibbon;
    final rootSplit: WorkspaceRoot;

    /**
     * Indicates the currently focused leaf, if one exists.
     *
     * Please avoid using `activeLeaf` directly, especially without checking whether
     * `activeLeaf` is null.
     *
     * The recommended alternatives are:
     * - If you need information about the current view, use {@link Workspace.getActiveViewOfType}.
     * - If you need to open a new file or navigate a view, use {@link Workspace.getLeaf}.
     *
     * @deprecated - The use of this field is discouraged.
     */
    final activeLeaf: Null<WorkspaceLeaf>;

    final containerEl: HtmlElement;
    final layoutReady: Bool;
    function requestSaveLayout(): Void;

    /**
     * A component managing the current editor. This can be null
     * if the active view has no editor.
     */
    final activeEditor: Null<MarkdownFileInfo>;

    /**
     * Runs the callback function right away if layout is already ready,
     * or push it to a queue to be called later when layout is ready.
     * */
    function onLayoutReady(callback: () -> Void): Void;

    function changeLayout(workspace: Any): Promise<Void>;
    function getLayout(): Any;
    function createLeafInParent(parent: WorkspaceSplit, index: Int): WorkspaceLeaf;
    function createLeafBySplit(leaf: WorkspaceLeaf, ?direction: SplitDirection, ?before: Bool): WorkspaceLeaf;

    function duplicateLeaf(leaf: WorkspaceLeaf, leafType: EitherType<PaneType, Bool>, ?direction: SplitDirection): Promise<WorkspaceLeaf>;

    /**
     * If newLeaf is false (or not set) then an existing leaf which can be navigated
     * is returned, or a new leaf will be created if there was no leaf available.
     *
     * If newLeaf is `'tab'` or `true` then a new leaf will be created in the preferred
     * location within the root split and returned.
     *
     * If newLeaf is `'split'` then a new leaf will be created adjacent to the currently active leaf.
     * If direction is `'vertical'`, the leaf will appear to the right.
     * If direction is `'horizontal'`, the leaf will appear below the current leaf.
     *
     * If newLeaf is `'window'` then a popout window will be created with a new leaf inside.
     */
    @:overload(function(newLeaf: SplitPanelType, ?direction: SplitDirection): WorkspaceLeaf {})
    function getLeaf(?newLeaf: EitherType<PaneType, Bool>): WorkspaceLeaf;

    /**
     * Migrates this leaf to a new popout window.
     * Only works on the desktop app.
     */
    function moveLeafToPopout(leaf: WorkspaceLeaf, ?data: WorkspaceWindowInitData): WorkspaceWindow;

    /**
     * Open a new popout window with a single new leaf and return that leaf.
     * Only works on the desktop app.
     */
    function openPopoutLeaf(?data: WorkspaceWindowInitData): WorkspaceLeaf;

    function openLinkText(linktext: String, sourcePath: String, ?newLeaf: EitherType<PaneType, Bool>, ?openViewState: OpenViewState): Promise<Void>;

    /**
     * Sets the active leaf
     * @param leaf - The new active leaf
     * @param params - Parameter object of whether to set the focus.
     */
    function setActiveLeaf(leaf: WorkspaceLeaf, ?params: { ?focus: Bool }): Void;

    function getLeafById(id: String): WorkspaceLeaf;
    function getGroupLeaves(group: String): Array<WorkspaceLeaf>;
    function getMostRecentLeaf(?root: WorkspaceParent): Null<WorkspaceLeaf>;
    function getLeftLeaf(split: Bool): WorkspaceLeaf;
    function getRightLeaf(split: Bool): WorkspaceLeaf;
    function getActiveViewOfType<T: View>(type: Any): Null<T>;

    /**
     * Returns the file for the current view if it's a FileView.
     *
     * Otherwise, it will recent the most recently active file.
     */
    function getActiveFile(): Null<TFile>;

    /**
     * Iterate through all leaves in the main area of the workspace.
     */
    function iterateRootLeaves(callback: (leaf: WorkspaceLeaf) -> Void): Void;

    /**
     * Iterate through all leaves, including main area leaves, floating leaves, and sidebar leaves.
     */
    function iterateAllLeaves(callback: (leaf: WorkspaceLeaf) -> Void): Void;

    function getLeavesOfType(viewType: String): Array<WorkspaceLeaf>;
    function detachLeavesOfType(viewType: String): Void;
    function revealLeaf(leaf: WorkspaceLeaf): Void;
    function getLastOpenFiles(): Array<String>;

    /**
     * Calling this function will update/reconfigure the options of all markdown panes.
     * It is fairly expensive, so it should not be called frequently.
     */
    function updateOptions(): Void;

    // function iterateCodeMirrors(callback: (cm: CodeMirror.Editor) -> Void): Void;

    @:overload(function(name: EventName_QuickPreview, callback: (file: TFile, data: String) -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_Resize, callback: () -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_ActiveLeafChange, callback: (leaf: Null<WorkspaceLeaf>) -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_FileOpen, callback: (file: Null<TFile>) -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_LayoutChange, callback: () -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_WindowOpen, callback: (win: WorkspaceWindow, window: Window) -> Void, ?ctx: Any): EventRef {})
    @:overload(function(name: EventName_WindowClose, callback: (win: WorkspaceWindow, window: Window) -> Void, ?ctx: Any): EventRef {})
    /** Triggered when the CSS of the app has changed. */
    @:overload(function(name: EventName_CssChange, callback: () -> Void, ?ctx: Any): EventRef {})
    /** Triggered when the user opens the context menu on a file. */
    @:overload(function(name: EventName_FileMenu, callback: (menu: Menu, file: TAbstractFile, source: String, ?leaf: WorkspaceLeaf) -> Void, ?ctx: Any): EventRef {})
    /** Triggered when the user opens the context menu with multiple files selected in the File Explorer. */
    @:overload(function(name: EventName_FilesMenu, callback: (menu: Menu, files: Array<TAbstractFile>, source: String, ?leaf: WorkspaceLeaf) -> Void, ?ctx: Any): EventRef {})
    /** Triggered when the user opens the context menu on an editor. */
    @:overload(function(name: EventName_EditorMenu, callback: (menu: Menu, editor: Editor, info: EitherType<MarkdownView, MarkdownFileInfo>) -> Void, ?ctx: Any): EventRef {})
    /** Triggered when changes to an editor has been applied, either programmatically or from a user event. */
    @:overload(function(name: EventName_EditorChange, callback: (editor: Editor, info: EitherType<MarkdownView, MarkdownFileInfo>) -> Void, ?ctx: Any): EventRef {})
    /**
     * Triggered when the editor receives a paste event.
     * Check for `evt.defaultPrevented` before attempting to handle this event, and return if it has been already handled.
     * Use `evt.preventDefault()` to indicate that you've handled the event.
     */
    @:overload(function(name: EventName_EditorPaste, callback: (evt: ClipboardEvent, editor: Editor, info: EitherType<MarkdownView, MarkdownFileInfo>) -> Void, ?ctx: Any): EventRef {})
    /**
     * Triggered when the editor receives a drop event.
     * Check for `evt.defaultPrevented` before attempting to handle this event, and return if it has been already handled.
     * Use `evt.preventDefault()` to indicate that you've handled the event.
     */
    @:overload(function(name: EventName_EditorDrop, callback: (evt: DragEvent, editor: Editor, info: EitherType<MarkdownView, MarkdownFileInfo>) -> Void, ?ctx: Any): EventRef {})
    // @:overload(function(name: EventName_Codemirror, callback: (cm: CodeMirror.Editor) -> Void, ?ctx: Any): EventRef {})

    /**
     * Triggered when the app is about to quit. Not guaranteed to actually run.
     * Perform some best effort cleanup here.
     */
    function on(name: EventName_Quit, callback: (tasks: Tasks) -> Void, ?ctx: Any): EventRef;
}

 enum abstract EventName_QuickPreview(String)     { var QuickPreview     = "quick-preview"; }
 enum abstract EventName_Resize(String)           { var Resize           = "resize"; }
 enum abstract EventName_ActiveLeafChange(String) { var ActiveLeafChange = "active-leaf-change"; }
 enum abstract EventName_FileOpen(String)         { var FileOpen         = "file-open"; }
 enum abstract EventName_LayoutChange(String)     { var LayoutChange     = "layout-change"; }
 enum abstract EventName_WindowOpen(String)       { var WindowOpen       = "window-open"; }
 enum abstract EventName_WindowClose(String)      { var WindowClose      = "window-close"; }
 enum abstract EventName_CssChange(String)        { var CssChange        = "css-change"; }
 enum abstract EventName_FileMenu(String)         { var FileMenu         = "file-menu"; }
 enum abstract EventName_FilesMenu(String)        { var FilesMenu        = "files-menu"; }
 enum abstract EventName_EditorMenu(String)       { var EditorMenu       = "editor-menu"; }
 enum abstract EventName_EditorChange(String)     { var EditorChange     = "editor-change"; }
 enum abstract EventName_EditorPaste(String)      { var EditorPaste      = "editor-paste"; }
 enum abstract EventName_EditorDrop(String)       { var EditorDrop       = "editor-drop"; }
 enum abstract EventName_Codemirror(String)       { var Codemirror       = "codemirror"; }
 enum abstract EventName_Quit(String)             { var Quit             = "quit"; }
