package obsidian;

import obsidian.Files.TFile;
import obsidian.Events.EventRef;

typedef Loc = { line: Int, col: Int, offset: Int }
typedef Pos = { start: Loc, end: Loc }
typedef CacheItem = { position: Pos }
typedef Reference = { link: String, original: String, ?displayText: String }
typedef ReferenceCache = Reference & CacheItem & {}
typedef LinkCache = ReferenceCache & {}
typedef EmbedCache = ReferenceCache & {}
typedef TagCache = CacheItem & { tag: String }
typedef HeadingCache = CacheItem & { heading: String, level: Int }
typedef SectionCache = CacheItem & { ?id: String, type: String }

typedef ListItemCache = CacheItem & {
    /** The block ID of this list item, if defined. */
    ?id: String,

    /**
     * A single character indicating the checked status of a task.
     * The space character `' '` is interpreted as an incomplete task.
     * An other character is interpreted as completed task.
     * `undefined` if this item isn't a task.
     */
    ?task: String,

    /**
     * Line number of the parent list item (position.start.line).
     * If this item has no parent (e.g. it's a root level list),
     * then this value is the negative of the line number of the first list item (start of the list).
     *
     * Can be used to deduce which list items belongs to the same group (item1.parent === item2.parent).
     * Can be used to reconstruct hierarchy information (parentItem.position.start.line === childItem.parent).
     */
    parent: Int
}

typedef FrontMatterCache = Map<String, Dynamic>;
typedef FrontmatterLinkCache = Reference & { key: String }
typedef BlockCache = CacheItem & { id: String }

typedef CachedMetadata = {
    final ?links: Array<LinkCache>;
    final ?embeds: Array<EmbedCache>;
    final ?tags: Array<TagCache>;
    final ?headings: Array<HeadingCache>;

    /** Sections are root level markdown blocks, which can be used to divide the document up. */
    final ?sections: Array<SectionCache>;
    final ?listItems: Array<ListItemCache>;
    final ?frontmatter: FrontMatterCache;
    final ?frontmatterPosition: Pos;
    final ?frontmatterLinks: Array<FrontmatterLinkCache>;
    final ?blocks: Map<String, BlockCache>;
}

/**
 * Linktext is any internal link that is composed of a path and a subpath, such as "My note#Heading"
 * Linkpath (or path) is the path part of a linktext
 * Subpath is the heading/block ID part of a linktext.
 */
extern class MetadataCache extends Events {

    /**
     * Get the best match for a linkpath.
     */
    function getFirstLinkpathDest(linkpath: String, sourcePath: String): Null<TFile>;

    function getFileCache(file: TFile): Null<CachedMetadata>;
    function getCache(path: String): Null<CachedMetadata>;

    /**
     * Generates a linktext for a file.
     *
     * If file name is unique, use the filename.
     * If not unique, use full path.
     */
    function fileToLinktext(file: TFile, sourcePath: String, ?omitMdExtension: Bool): String;

    /**
     * Contains all resolved links. This object maps each source file's path to an object of destination file paths with the link count.
     * Source and destination paths are all vault absolute paths that comes from `TFile.path` and can be used with `Vault.getAbstractFileByPath(path)`.
     */
    final resolvedLinks: Map<String, Map<String, Int>>;

    /**
     * Contains all unresolved links. This object maps each source file to an object of unknown destinations with count.
     * Source paths are all vault absolute paths, similar to `resolvedLinks`.
     */
    final unresolvedLinks: Map<String, Map<String, Int>>;

    /**
     * Called when a file has been indexed, and its (updated) cache is now available.
     *
     * Note: This is not called when a file is renamed for performance reasons.
     * You must hook the vault rename event for those.
     * (Details: https://github.com/obsidianmd/obsidian-api/issues/77)
     */
    @:overload(function(name: ChangedEventName, callback: (file: TFile, data: String, cache: CachedMetadata) -> Void, ?ctx: Any): EventRef {})

    /**
     * Called when a file has been deleted. A best-effort previous version of the cached metadata is presented,
     * but it could be null in case the file was not successfully cached previously.
     * @public
     */
    @:overload(function(name: DeletedEventName, callback: (file: TFile, prevCache: Null<CachedMetadata>) -> Void, ?ctx: Any): EventRef {})

    /**
     * Called when a file has been resolved for `resolvedLinks` and `unresolvedLinks`.
     * This happens sometimes after a file has been indexed.
     * @public
     */
    @:overload(function(name: ResolveEventName, callback: (file: TFile) -> Void, ?ctx: Any): EventRef {})

   /**
     * Called when all files has been resolved. This will be fired each time files get modified after the initial load.
     * @public
     */
    function on(name: ResolvedEventName, callback: () -> Void, ?ctx: Any): EventRef;
}

enum abstract ChangedEventName(String) { var Changed = "changed"; }
enum abstract DeletedEventName(String) { var Deleted = "deleted"; }
enum abstract ResolveEventName(String) { var Resolve = "resolve"; }
enum abstract ResolvedEventName(String) { var Resolved = "resolved"; }
