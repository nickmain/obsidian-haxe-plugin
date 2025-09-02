package obsidian;

interface MarkdownPostProcessor {
    /**
     * An optional integer sort order. Defaults to 0. Lower number runs before higher numbers.
     */
    var sortOrder: Null<Float>;
}