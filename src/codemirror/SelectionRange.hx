package codemirror;

enum abstract Association(Int) {
    var Before = -1;
    var None = 0;
    var After = 1;
}

/**
A single selection range. When
[`allowMultipleSelections`](https://codemirror.net/6/docs/ref/#state.EditorState^allowMultipleSelections)
is enabled, a [selection](https://codemirror.net/6/docs/ref/#state.EditorSelection) may hold
multiple ranges. By default, selections hold exactly one range.
*/
extern class SelectionRange {
    /** The lower boundary of the range. */
    final from: Int;

    /** The upper boundary of the range. */
    final to: Int;

    private function new();

    /** The anchor of the range—the side that doesn't move when you extend it. */
    final anchor: Int;

    /**
    The head of the range, which is moved when the range is
    [extended](https://codemirror.net/6/docs/ref/#state.SelectionRange.extend).
    */
    final head: Int;

    /** True when `anchor` and `head` are at the same position. */
    final empty: Bool;

    /**
    If this is a cursor that is explicitly associated with the
    character on one of its sides, this returns the side. -1 means
    the character before its position, 1 the character after, and 0
    means no association.
    */
    final assoc: Association;

    /** The bidirectional text level associated with this cursor, if any. */
    final bidiLevel: Null<Int>;

    /**
    The goal column (stored vertical offset) associated with a
    cursor. This is used to preserve the vertical position when
    [moving](https://codemirror.net/6/docs/ref/#view.EditorView.moveVertically) across
    lines of different length.
    */
    final goalColumn: Null<Int>;

    /** Map this range through a change, producing a valid range in the updated document. */
    function map(change: ChangeDesc, ?assoc: Int): SelectionRange;

    /** Extend this range to cover at least `from` to `to`. */
    function extend(from: Int, ?to: Int): SelectionRange;

    /** Compare this range to another range. */
    function eq(other: SelectionRange): Bool;

    /** Return a JSON-serializable object representing the range. */
    function toJSON(): Dynamic;

    /** Convert a JSON representation of a range to a `SelectionRange` instance. */
    static function fromJSON(json: Dynamic): SelectionRange;
}
