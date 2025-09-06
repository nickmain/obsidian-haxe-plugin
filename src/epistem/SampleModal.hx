package epistem;

import obsidian.Obsidian;
import obsidian.Modal;
import obsidian.App;

class SampleModal extends Modal {
    public function new(app: App) {
        super(app);
    }

    public function onOpen(): Void {
        titleEl.innerText = "Sample Modal";
        contentEl.innerHTML = 'This is a sample modal dialog.<br>Version: ${Obsidian.apiVersion}';
    }

    public function onClose(): Void {
        // Cleanup if necessary
    }
}
