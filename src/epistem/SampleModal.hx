package epistem;

import obsidian.Modal;
import obsidian.App;

class SampleModal extends Modal {
    public function new(app: App) {
        super(app);
    }

    public function onOpen(): Void {
        titleEl.innerText = "Sample Modal";
        contentEl.innerText = "This is a sample modal dialog.";
    }

    public function onClose(): Void {
        // Cleanup if necessary
    }
}
