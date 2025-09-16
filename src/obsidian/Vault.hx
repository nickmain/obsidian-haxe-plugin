package obsidian;

import obsidian.Data.DataWriteOptions;
import obsidian.Data.DataAdapter;
import js.lib.Promise;
import js.lib.ArrayBuffer;
import obsidian.Events.EventRef;
import obsidian.Files.TFile;
import obsidian.Files.TAbstractFile;
import obsidian.Files.TFolder;

enum abstract EventName(String) {
    var Create = "create";
    var Modify = "modify";
    var Delete = "delete";
}

enum abstract RenameEventName(String) {
    var Rename = "rename";
}

extern class Vault extends Events {
    final adapter: DataAdapter;

    /**
     * Gets the path to the config folder.
     * This value is typically `.obsidian` but it could be different.
     */
    final configDir: String;

    /**
     * Gets the name of the vault.
     */
    function getName(): String;

    /**
     * Get a file or folder inside the vault. If you need a file, you should test the returned object with `instanceof TFile`. Otherwise, if you need a folder, you should test it with `instanceof TFolder`.
     * @param path - vault absolute path to the folder or file, with extension, case sensitive.
     * @returns the abstract file, if it's found.
     */
    function getAbstractFileByPath(path: String): Null<TAbstractFile>;

    /**
     * Get the root folder of the current vault.
     */
    function getRoot(): TFolder;

    /**
     * Create a new plaintext file inside the vault.
     * @param path - Vault absolute path for the new file, with extension.
     * @param data - text content for the new file.
     * @param options - (Optional)
     */
    function create(path: String, data: String, ?options: DataWriteOptions): Promise<TFile>;

    /**
     * Create a new binary file inside the vault.
     * @param path - Vault absolute path for the new file, with extension.
     * @param data - content for the new file.
     * @param options - (Optional)
     * @throws Error if file already exists
     */
    function createBinary(path: String, data: ArrayBuffer, ?options: DataWriteOptions): Promise<TFile>;

    /**
     * Create a new folder inside the vault.
     * @param path - Vault absolute path for the new folder.
     * @throws Error if folder already exists
     */
    function createFolder(path: String): Promise<TFolder>;

    /**
     * Read a plaintext file that is stored inside the vault, directly from disk.
     * Use this if you intend to modify the file content afterwards.
     * Use {@link Vault.cachedRead} otherwise for better performance.
     */
    function read(file: TFile): Promise<String>;

    /**
     * Read the content of a plaintext file stored inside the vault
     * Use this if you only want to display the content to the user.
     * If you want to modify the file content afterward use {@link Vault.read}
     */
    function cachedRead(file: TFile): Promise<String>;

    /**
     * Read the content of a binary file stored inside the vault.
     */
    function readBinary(file: TFile): Promise<ArrayBuffer>;

    /**
     * Returns an URI for the browser engine to use, for example to embed an image.
     */
    function getResourcePath(file: TFile): String;

    /**
     * Deletes the file completely.
     * @param file - The file or folder to be deleted
     * @param force - Should attempt to delete folder even if it has hidden children
     */
    function delete(file: TAbstractFile, ?force: Bool): Promise<Void>;

    /**
     * Tries to move to system trash. If that isn't successful/allowed, use local trash
     * @param file - The file or folder to be deleted
     * @param system - Set to `false` to use local trash by default.
     */
    function trash(file: TAbstractFile, system: Bool): Promise<Void>;

    /**
     * Rename or move a file.
     * @param file - the file to rename/move
     * @param newPath - vault absolute path to move file to.
     */
    function rename(file: TAbstractFile, newPath: String): Promise<Void>;

    /**
     * Modify the contents of a plaintext file.
     * @param file - The file
     * @param data - The new file content
     * @param options - (Optional)
     */
    function modify(file: TFile, data: String, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Modify the contents of a binary file.
     * @param file - The file
     * @param data - The new file content
     * @param options - (Optional)
     */
    function modifyBinary(file: TFile, data: ArrayBuffer, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Add text to the end of a plaintext file inside the vault.
     * @param file - The file
     * @param data - the text to add
     * @param options - (Optional)
     */
    function append(file: TFile, data: String, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Atomically read, modify, and save the contents of a note.
     * @param file - the file to be read and modified.
     * @param fn - a callback function which returns the new content of the note synchronously.
     * @param options - write options.
     * @returns string - the text value of the note that was written.
     */
    function process(file: TFile, fn: (data: String) -> String, ?options: DataWriteOptions): Promise<String>;

    /**
     * Create a copy of the selected file.
     * @param file - The file
     * @param newPath - Vault absolute path for the new copy.
     */
    function copy(file: TFile, newPath: String): Promise<TFile>;

    /**
     * Get all files and folders in the vault.
     */
    function getAllLoadedFiles(): Array<TAbstractFile>;

    /**
     * @public
     */
    static function recurseChildren(root: TFolder, cb: (file: TAbstractFile) -> Void): Void;

    /**
     * Get all markdown files in the vault.
     */
    function getMarkdownFiles(): Array<TFile>;

    /**
     * Get all files in the vault.
     */
    function getFiles(): Array<TFile>;

    /**
     * Called when a file is created, modified, renamed, or deleted in the vault.
     * This is also called when the vault is first loaded for each existing file
     * If you do not wish to receive create events on vault load, register your event handler inside {@link Workspace.onLayoutReady}.
     */
    @:overload(function(name: RenameEventName, callback: (file: TAbstractFile, oldPath: String) -> Void, ?ctx: Any): EventRef {})
    function on(name: EventName, callback: (file: TAbstractFile) -> Void, ?ctx: Any): EventRef;
}
