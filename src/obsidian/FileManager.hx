package obsidian;

import obsidian.Data.DataWriteOptions;
import js.lib.Promise;
import obsidian.Files.TFolder;
import obsidian.Files.TFile;
import obsidian.Files.TAbstractFile;

/**
 * Manage the creation, deletion and renaming of files from the UI.
 */
extern class FileManager {

    /**
     * Gets the folder that new files should be saved to, given the user's preferences.
     * @param sourcePath - The path to the current open/focused file,
     * used when the user wants new files to be created "in the same folder".
     * Use an empty string if there is no active file.
     * @param newFilePath - The path to the file that will be newly created,
     * used to infer what settings to use based on the path's extension.
     */
    function getNewFileParent(sourcePath: String, ?newFilePath: String): TFolder;

    /**
     * Rename or move a file safely, and update all links to it depending on the user's preferences.
     * @param file - the file to rename
     * @param newPath - the new path for the file
     */
    function renameFile(file: TAbstractFile, newPath: String): Promise<Void>;

    /**
     * Generate a markdown link based on the user's preferences.
     * @param file - the file to link to.
     * @param sourcePath - where the link is stored in, used to compute relative links.
     * @param subpath - A subpath, starting with `#`, used for linking to headings or blocks.
     * @param alias - The display text if it's to be different than the file name. Pass empty string to use file name.
     */
    function generateMarkdownLink(file: TFile, sourcePath: String, ?subpath: String, ?alias: String): String;

    /**
     * Atomically read, modify, and save the frontmatter of a note.
     * The frontmatter is passed in as a JS object, and should be mutated directly to achieve the desired result.
     *
     * Remember to handle errors thrown by this method.
     *
     * @param file - the file to be modified. Must be a markdown file.
     * @param fn - a callback function which mutates the frontMatter object synchronously.
     * @param options - write options.
     * @throws YAMLParseError if the YAML parsing fails
     * @throws any errors that your callback function throws
     */
    function processFrontMatter(file: TFile, fn: (frontmatter: Dynamic) -> Void, ?options: DataWriteOptions): Promise<Void>;
}