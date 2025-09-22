package codemirror;

typedef LineNumberConfig = {
    // /** How to display line numbers. Defaults to simply converting them to string. */
    // ?formatNumber: (lineNo: Int, state: EditorState) -> String,
    // /** Supply event handlers for DOM events on this gutter. */
    // ?domEventHandlers: Handlers
}

@:jsRequire("@codemirror/view")
extern class CodeMirrorView {

    /** Create a line number gutter extension. */
    static function lineNumbers(?config: LineNumberConfig): Extension;
}