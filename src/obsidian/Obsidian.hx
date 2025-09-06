package obsidian;

import obsidian.Setting.TooltipOptions;
import js.html.Element;
import js.html.DocumentFragment;
import js.lib.ArrayBuffer;
import haxe.extern.EitherType;
import js.lib.Promise;
import obsidian.MetadataCache.CachedMetadata;
import js.html.svg.SVGElement;

/** Text position offsets within text file. Represents a text range [from offset, to offset]. */
typedef SearchMatchPart = Array<Int>;
typedef PreparedQuery = { query: String, tokens: Array<String>, fuzzy: Array<String> }
typedef SearchMatches = Array<SearchMatchPart>;
typedef SearchResult = { score: Float, matches: SearchMatches }

typedef RequestUrlParam = {
    var url: String;
    var ?method: String;
    var ?contentType: String;
    var ?body: EitherType<String, ArrayBuffer>;
    var ?headers: Map<String, String>;
    /** Whether to throw an error when the status code is 400+. Defaults to true */
    // var ?throw: Bool;
}

typedef RequestUrlResponse = { status: Int, headers: Map<String, String>, arrayBuffer: ArrayBuffer, json: Dynamic, text: String }
extern class RequestUrlResponsePromise extends Promise<RequestUrlResponse> {
    final arrayBuffer: Promise<ArrayBuffer>; 
    final json: Promise<Dynamic>; 
    final text: Promise<String>;
}

@:jsRequire("obsidian")
extern class Obsidian {
    static final apiVersion: String;
    static function requireApiVersion(version: String): Bool;

    static function addIcon(iconId: String, svgContent: String): Void;
    static function removeIcon(iconId: String): Void;
    static function getIconIds(): Array<String>;

    /** Insert an SVG into the element from an iconId. Does nothing if no icon associated with the iconId. */
    static function setIcon(parent: Element, iconId: String): Void;
    
    /** Create an SVG from an iconId. Returns null if no icon associated with the iconId. */
    static function getIcon(iconId: String): Null<SVGElement>;

    static function setTooltip(el: Element, tooltip: String, ?options: TooltipOptions): Void;

    static function getLinkpath(linktext: String): String;

    static function getAllTags(cache: CachedMetadata): Null<Array<String>>;

    static function parseYaml(yaml: String): Dynamic;

    static function parseLinktext(linktext: String): { path: String, subpath: String };

    static function stringifyYaml(obj: Dynamic): String;

    /** Normalizes headings for link matching by stripping out special characters and shrinking consecutive spaces. */
    static function stripHeading(heading: String): String;

    /** Prepares headings for linking. It strips out some bad combinations of special characters that could break links. */
    static function stripHeadingForLink(heading: String): String;

    static function normalizePath(path: String): String;

    static function sanitizeHTMLToDom(html: String): DocumentFragment;

    static function prepareQuery(query: String): PreparedQuery;

    /**
     * Construct a simple search callback that runs on a target string.
     * @param query - the space-separated words
     * @return fn - the callback function to apply the search on
     */
    static function prepareSimpleSearch(query: String): (text: String) -> Null<SearchResult>;

    /**
     * Construct a fuzzy search callback that runs on a target string.
     * Performance may be an issue if you are running the search for more than a few thousand times.
     * If performance is a problem, consider using `prepareSimpleSearch` instead.
     * @param query - the fuzzy query.
     * @return fn - the callback function to apply the search on.
     */
    static function prepareFuzzySearch(query: String): (text: String) -> Null<SearchResult>;

    static function fuzzySearch(q: PreparedQuery, text: String): Null<SearchResult>;

    /**
     * Similar to `fetch()`, request a URL using HTTP/HTTPS, without any CORS restrictions.
     * Returns the text value of the response.
     */
    static function request(request: EitherType<RequestUrlParam, String>): Promise<String>;

    /**
     * Similar to `fetch()`, request a URL using HTTP/HTTPS, without any CORS restrictions.
     */
    static function requestUrl(request: EitherType<RequestUrlParam, String>): RequestUrlResponsePromise;
}
