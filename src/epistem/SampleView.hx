package epistem;

import obsidian.WorkspaceLeaf;
import obsidian.View;
import js.lib.Promise;

class SampleView extends ItemView {

    public static final VIEW_TYPE: String = "sample-view";

    public function new(leaf: WorkspaceLeaf) {
        super(leaf);
        icon = "aperture";
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
        return Promise.resolve();
    }

    override function onClose(): Promise<Void> {
        trace("SampleView closed");
        return super.onClose();
    }

    function buildUI() {
        contentEl.innerHTML = "";
        contentEl.innerHTML = "<p>Hello from SampleView!</p>";
    }
}