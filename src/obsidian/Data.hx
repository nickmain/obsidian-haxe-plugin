package obsidian;

import js.lib.Promise;
import js.lib.ArrayBuffer;
import obsidian.Files.Stat;

typedef DataWriteOptions = {
    /**
     * Time of creation, represented as a unix timestamp, in milliseconds.
     * Omit this if you want to keep the default behaviour.
     * */
    var ctime: Float;

    /**
     * Time of last modification, represented as a unix timestamp, in milliseconds.
     * Omit this if you want to keep the default behaviour.
     */
    var ?mtime: Float;
}

interface ListedFiles {
    final files: Array<String>;
    final folders: Array<String>;
}

interface DataAdapter {

    function getName(): String;

    /**
     * Check if something exists at the given path.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     * @param sensitive - Some file systems/operating systems are case-insensitive, set to true to force a case-sensitivity check.
     */
    function exists(normalizedPath: String, ?sensitive: Bool): Promise<Bool>;

    /**
     * Retrieve metadata about the given file/folder.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     */
    function stat(normalizedPath: String): Promise<Null<Stat>>;

    /**
     * Retrieve a list of all files and folders inside the given folder, non-recursive.
     * @param normalizedPath - path to folder, use {@link normalizePath} to normalize beforehand.
     */
    function list(normalizedPath: String): Promise<ListedFiles>;

    /**
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     */
    function read(normalizedPath: String): Promise<String>;

    /**
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     */
    function readBinary(normalizedPath: String): Promise<ArrayBuffer>;

    /**
     * Write to a plaintext file.
     * If the file exists its content will be overwritten, otherwise the file will be created.
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     * @param data - new file content
     * @param options - (Optional)
     */
    function write(normalizedPath: String, data: String, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Write to a binary file.
     * If the file exists its content will be overwritten, otherwise the file will be created.
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     * @param data - the new file content
     * @param options - (Optional)
     */
    function writeBinary(normalizedPath: String, data: ArrayBuffer, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Add text to the end of a plaintext file.
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     * @param data - the text to append.
     * @param options - (Optional)
     */
    function append(normalizedPath: String, data: String, ?options: DataWriteOptions): Promise<Void>;

    /**
     * Atomically read, modify, and save the contents of a plaintext file.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     * @param fn - a callback function which returns the new content of the file synchronously.
     * @param options - write options.
     * @returns string - the text value of the file that was written.
     */
    function process(normalizedPath: String, fn: (data: String) -> String, ?options: DataWriteOptions): Promise<String>;

    /**
     * Returns an URI for the browser engine to use, for example to embed an image.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     */
    function getResourcePath(normalizedPath: String): String;

    /**
     * Create a directory.
     * @param normalizedPath - path to use for new folder, use {@link normalizePath} to normalize beforehand.
     */
    function mkdir(normalizedPath: String): Promise<Void>;

    /**
     * Try moving to system trash.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     * @returns Returns true if succeeded. This can fail due to system trash being disabled.
     */
    function trashSystem(normalizedPath: String): Promise<Bool>;

    /**
     * Move to local trash.
     * Files will be moved into the `.trash` folder at the root of the vault.
     * @param normalizedPath - path to file/folder, use {@link normalizePath} to normalize beforehand.
     */
    function trashLocal(normalizedPath: String): Promise<Void>;

    /**
     * Remove a directory.
     * @param normalizedPath - path to folder, use {@link normalizePath} to normalize beforehand.
     * @param recursive - If `true`, delete folders under this folder recursively, if `false´ the folder needs to be empty.
     */
    function rmdir(normalizedPath: String, recursive: Bool): Promise<Void>;

    /**
     * Delete a file.
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     */
    function remove(normalizedPath: String): Promise<Void>;

    /**
     * Rename a file or folder.
     * @param normalizedPath - current path to file/folder, use {@link normalizePath} to normalize beforehand.
     * @param normalizedNewPath - new path to file/folder, use {@link normalizePath} to normalize beforehand.
     */
    function rename(normalizedPath: String, normalizedNewPath: String): Promise<Void>;

    /**
     * Create a copy of a file.
     * This will fail if there is already a file at `normalizedNewPath`.
     * @param normalizedPath - path to file, use {@link normalizePath} to normalize beforehand.
     * @param normalizedNewPath - path to file, use {@link normalizePath} to normalize beforehand.
     */
    function copy(normalizedPath: String, normalizedNewPath: String): Promise<Void>;
}
