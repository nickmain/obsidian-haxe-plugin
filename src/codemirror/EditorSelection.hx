package codemirror;

/**
An editor selection holds one or more selection ranges.
*/
extern class EditorSelection {
    /** The ranges in the selection, sorted by position. Ranges cannot overlap (but they may touch, if they aren't empty). */
    final ranges: Array<SelectionRange>;

    /** The index of the _main_ range in the selection (which is usually the range that was added last).*/
    final mainIndex: Int;

    private function new();

    /** Map a selection through a change. Used to adjust the selection position for changes. */
    function map(change: ChangeDesc, ?assoc: Int): EditorSelection;

    /** Compare this selection to another selection. */
    function eq(other: EditorSelection): Bool;

    /**
    Get the primary selection range. Usually, you should make sure
    your code applies to _all_ ranges, by using methods like
    [`changeByRange`](https://codemirror.net/6/docs/ref/#state.EditorState.changeByRange).
    */
    final main: SelectionRange;

    /** Make sure the selection only has one range. Returns a selection holding only the main range from this selection. */
    function asSingle(): EditorSelection;

    /** Extend this selection with an extra range. */
    function addRange(range: SelectionRange, ?main: Bool): EditorSelection;

    /** Replace a given range with another range, and then normalize the selection to merge and sort ranges if necessary. */
    function replaceRange(range: SelectionRange, ?which: Int): EditorSelection;

    /** Convert this selection to an object that can be serialized to JSON. */
    function toJSON(): Dynamic;

    /** Create a selection from a JSON representation. */
    static function fromJSON(json: Dynamic): EditorSelection;

    /** Create a selection holding a single range. */
    static function single(anchor: Int, ?head: Int): EditorSelection;

    /** Sort and merge the given set of ranges, creating a valid selection. */
    static function create(ranges: Array<SelectionRange>, ?mainIndex: Int): EditorSelection;

    /** Create a cursor selection range at the given position. You can safely ignore the optional arguments in most situations. */
    static function cursor(pos: Int, ?assoc: Int, ?bidiLevel: Int, ?goalColumn: Int): SelectionRange;

    /** Create a selection range. */
    static function range(anchor: Int, head: Int, ?goalColumn: Int, ?bidiLevel: Int): SelectionRange;
}
