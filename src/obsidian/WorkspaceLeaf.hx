package obsidian;

import obsidian.Files.TFile;
import js.html.Window;
import js.html.Document;
import js.lib.Promise;
import obsidian.Events.EventRef;
import obsidian.View.ViewState;
import obsidian.View.OpenViewState;

extern abstract class WorkspaceParent extends WorkspaceItem {}
extern class WorkspaceSplit extends WorkspaceParent {}
extern abstract class WorkspaceContainer extends WorkspaceSplit {
    final win: Window;
    final doc: Document;
}
extern class WorkspaceWindow extends WorkspaceContainer {}

extern abstract class WorkspaceItem extends Events {
    function getRoot(): WorkspaceItem;

    /**
     * Get the root container parent item, which can be one of:
     * - {@link WorkspaceRoot}
     * - {@link WorkspaceWindow}
     */
    function getContainer(): WorkspaceContainer;
}

extern class WorkspaceRoot extends WorkspaceContainer {}

extern class WorkspaceSidedock extends WorkspaceSplit {
    final collapsed: Bool;
    function toggle(): Void;
    function collapse(): Void;
    function expand(): Void;
}

extern class WorkspaceLeaf extends WorkspaceItem {
    final view: View;

    /**
     * By default, `openFile` will also make the leaf active.
     * Pass in `{ active: false }` to override.
     */
    function openFile(file: TFile, ?openState: OpenViewState): Promise<Void>;

    function open(view: View): Promise<View>;
    function getViewState(): ViewState;
    function setViewState(viewState: ViewState, ?eState: Any): Promise<Void>;
    function getEphemeralState(): Any;
    function setEphemeralState(state: Any): Void;
    function togglePinned(): Void;
    function setPinned(pinned: Bool): Void;
    function setGroupMember(other: WorkspaceLeaf): Void;
    function setGroup(group: String): Void;
    function detach(): Void;
    function getIcon(): String;
    function getDisplayText(): String;
    function onResize(): Void;

    @:overload(function(name: EventName_PinnedChange, callback: (pinned: Bool) -> Void, ?ctx: Any): EventRef {})
    function on(name: EventName_GroupChange, callback: (group: String) -> Void, ?ctx: Any): EventRef;
}

enum abstract EventName_PinnedChange(String) { var PinnedChange = "pinned-change"; }
enum abstract EventName_GroupChange(String) { var GroupChange = "group-change"; }
