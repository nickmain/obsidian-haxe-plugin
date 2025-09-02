package obsidian;

typedef EditorPosition = { line: Float, ch: Float }
typedef EditorSelection = { anchor: EditorPosition, head: EditorPosition }
typedef EditorSelectionOrCaret = { anchor: EditorPosition, ?head: EditorPosition }
typedef EditorRange = { from: EditorPosition, to: EditorPosition }
typedef EditorChange = EditorRangeOrCaret & { text: String }
typedef EditorTransaction = {
    ?replaceSelection: String,
    ?changes: Array<EditorChange>,
    ?selections: Array<EditorRangeOrCaret>, // Multiple selections, overrides `selection`.
    ?selection: Array<EditorRangeOrCaret>
}

enum abstract EditorCursorType(String) {
    var From = "from";
    var To = "to";
    var head = "head";
    var Anchor = "anchor";
}

enum abstract EditorCommandName(String) {
    var GoUp = "goUp";
    var GoDown = "goDown";
    var GoLeft = "goLeft";
    var GoRight = "goRight";
    var GoStart = "goStart";
    var GoEnd = "goEnd";
    var GoWordLeft = "goWordLeft";
    var GoWordRight = "goWordRight";
    var IndentMore = "indentMore";
    var IndentLess = "indentLess";
    var NewlineAndIndent = "newlineAndIndent";
    var SwapLineUp = "swapLineUp";
    var SwapLineDown = "swapLineDown";
    var DeleteLine = "deleteLine";
    var ToggleFold = "toggleFold";
    var FoldAll = "foldAll";
    var UnfoldAll = "unfoldAll";
}

interface Editor {
    function getDoc(): Editor;
    function refresh(): Void;
    function getValue(): String;
    function setValue(content: String): Void;
    function getLine(line: Float): String;
    function setLine(n: Float, text: String): Void;
    function lineCount(): Float;
    function lastLine(): Float;
    function getSelection(): String;
    function somethingSelected(): Bool;
    function getRange(from: EditorPosition, to: EditorPosition): String;
    function replaceSelection(replacement: String, ?origin: String): Void;
    function replaceRange(replacement: String, from: EditorPosition, ?to: EditorPosition, ?origin: String): Void;
    function getCursor(?string: EditorCursorType): EditorPosition;
    function listSelections(): Array<EditorSelection>;
    function setCursor(pos: EditorPosition): Void;
    function setSelection(anchor: EditorPosition, ?head: EditorPosition): Void;
    function setSelections(ranges: Array<EditorSelectionOrCaret>, ?main: Float): Void;
    function focus(): Void;
    function blur(): Void;
    function hasFocus(): Bool;
    function getScrollInfo(): { top: Float, left: Float };
    function scrollTo(?x: Null<Float>, ?y: Null<Float>): Void;
    function scrollIntoView(range: EditorRange, ?center: Bool): Void;
    function undo(): Void;
    function redo(): Void;
    function exec(command: EditorCommandName): Void;
    function transaction(tx: EditorTransaction, ?origin: String): Void;
    function wordAt(pos: EditorPosition): Null<EditorRange>;
    function posToOffset(pos: EditorPosition): Float;
    function offsetToPos(offset: Float): EditorPosition;

    function processLines<T>(read: (line: Float, lineText: String) -> Null<T>,
                             write: (line: Float, lineText: Float, value: Null<T>) -> EditorChange,
                             ?ignoreEmpty: Bool): Void;
}