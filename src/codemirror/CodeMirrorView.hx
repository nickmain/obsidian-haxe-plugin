package codemirror;

import js.html.Event;
import epistem.js.JSObjectMap;

typedef Handlers = JSObjectMap<(view: EditorView, line: BlockInfo, event: Event) -> Bool>;

/** Basic rectangle type. */
typedef Rect = { left: Int, right: Int, top: Int, bottom: Int };

typedef LineNumberConfig = {
    /** How to display line numbers. Defaults to simply converting them to string. */
    var ?formatNumber: (lineNo: Int, state: EditorState) -> String;

    /** Supply event handlers for DOM events on this gutter. */
    var ?domEventHandlers: Handlers;
}

@:jsRequire("@codemirror/view")
extern class CodeMirrorView {

    /** Create a line number gutter extension. */
    static function lineNumbers(?config: LineNumberConfig): Extension;

    /**
    Facet used for registering keymaps.
    You can add multiple keymaps to an editor. Their priorities determine their
    precedence (the ones specified early or with high priority get checked first).
    When a handler has returned `true` for a given key, no further handlers are called.
    */
    static final keymap: Facet<Array<KeyBinding>, Array<Array<KeyBinding>>>;
}