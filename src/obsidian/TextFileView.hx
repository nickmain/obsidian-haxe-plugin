package obsidian;

import js.lib.Promise;
import obsidian.View.FileView;
import obsidian.Files.TFile;

extern abstract class EditableFileView extends FileView {}

/**
 * This class implements a plaintext-based editable file view, which can be loaded and saved given an editor.
 *
 * Note that by default, this view only saves when it's closing. To implement auto-save, your editor should
 * call `this.requestSave()` when the content is changed.
 */
 @:jsRequire("obsidian", "TextFileView")
extern abstract class TextFileView extends EditableFileView {

    /**
     * In memory data
     */
    var data: String;

    /**
     * Debounced save in 2 seconds from now
     */
    final requestSave: () -> Void;

    function new(leaf: WorkspaceLeaf);

    function onUnloadFile(file: TFile): Promise<Void>;
    function onLoadFile(file: TFile): Promise<Void>;
    function save(?clear: Bool): Promise<Void>;

    /**
     * Gets the data from the editor. This will be called to save the editor contents to the file.
     */
    abstract function getViewData(): String;

    /**
     * Set the data to the editor. This is used to load the file contents.
     *
     * If clear is set, then it means we're opening a completely different file.
     * In that case, you should call clear(), or implement a slightly more efficient
     * clearing mechanism given the new data to be set.
     */
    abstract function setViewData(data: String, clear: Bool): Void;

    /**
     * Clear the editor. This is usually called when we're about to open a completely
     * different file, so it's best to clear any editor states like undo-redo history,
     * and any caches/indexes associated with the previous file contents.
     * @public
     */
    abstract function clear(): Void;
}
