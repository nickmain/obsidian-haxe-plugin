package codemirror;

import haxe.extern.EitherType;

/**
A change description is a variant of [change set](https://codemirror.net/6/docs/ref/#state.ChangeSet)
that doesn't store the inserted text. As such, it can't be
applied, but is cheaper to store and manipulate.
*/
extern class ChangeDesc {
    /** The length of the document before the change. */
    final length: Int;

    /** The length of the document after the change. */
    final newLength: Int;

    /** False when there are actual changes in this set. */
    final empty: Bool;

    /**
    Iterate over the unchanged parts left by these changes. `posA`
    provides the position of the range in the old document, `posB`
    the new position in the changed document.
    */
    function iterGaps(f: (posA: Int, posB: Int, length: Int) -> Void): Void;

    /**
    Iterate over the ranges changed by these changes. (See
    [`ChangeSet.iterChanges`](https://codemirror.net/6/docs/ref/#state.ChangeSet.iterChanges) for a
    variant that also provides you with the inserted text.)
    `fromA`/`toA` provides the extent of the change in the starting
    document, `fromB`/`toB` the extent of the replacement in the
    changed document.

    When `individual` is true, adjacent changes (which are kept
    separate for [position mapping](https://codemirror.net/6/docs/ref/#state.ChangeDesc.mapPos)) are
    reported separately.
    */
    function iterChangedRanges(f: (fromA: Int, toA: Int, fromB: Int, toB: Int) -> Void, ?individual: Bool): Void;

    /** Get a description of the inverted form of these changes. */
    final invertedDesc: ChangeDesc;

    /**
    Compute the combined effect of applying another set of changes
    after this one. The length of the document after this set should
    match the length before `other`.
    */
    function composeDesc(other: ChangeDesc): ChangeDesc;

    /**
    Map this description, which should start with the same document
    as `other`, over another set of changes, so that it can be
    applied after it. When `before` is true, map as if the changes
    in `other` happened before the ones in `this`.
    */
    function mapDesc(other: ChangeDesc, ?before: Bool): ChangeDesc;

    /**
    Map a given position through these changes, to produce a
    position pointing into the new document.

    `assoc` indicates which side the position should be associated
    with. When it is negative or zero, the mapping will try to keep
    the position close to the character before it (if any), and will
    move it before insertions at that point or replacements across
    that point. When it is positive, the position is associated with
    the character after it, and will be moved forward for insertions
    at or replacements across the position. Defaults to -1.

    `mode` determines whether deletions should be
    [reported](https://codemirror.net/6/docs/ref/#state.MapMode). It defaults to
    [`MapMode.Simple`](https://codemirror.net/6/docs/ref/#state.MapMode.Simple) (don't report
    deletions).
    */
    @:overload(function(pos: Int, ?assoc: Int): Int {})
    function mapPos(pos: Int, assoc: Int, mode: MapMode): Null<Int>;

    /**
    Check whether these changes touch a given range. When one of the
    changes entirely covers the range, the string `"cover"` is
    returned.
    */
    function touchesRange(from: Int, ?to: Int): EitherType<Bool, String>;

    /** Serialize this change desc to a JSON-representable value. */
    function toJSON(): Array<Int>;

    /**
    Create a change desc from its JSON representation (as produced
    by [`toJSON`](https://codemirror.net/6/docs/ref/#state.ChangeDesc.toJSON).
    */
    static function fromJSON(json: Dynamic): ChangeDesc;
}