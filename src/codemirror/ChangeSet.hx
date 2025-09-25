package codemirror;

import haxe.extern.EitherType;

/**
This type is used as argument to
[`EditorState.changes`](https://codemirror.net/6/docs/ref/#state.EditorState.changes) and in the
[`changes` field](https://codemirror.net/6/docs/ref/#state.TransactionSpec.changes) of transaction
specs to succinctly describe document changes. It may either be a
plain object describing a change (a deletion, insertion, or
replacement, depending on which fields are present), a [change
set](https://codemirror.net/6/docs/ref/#state.ChangeSet), or an array of change specs.
*/
typedef ChangeSpec = EitherType<{ from: Int, ?to: Int, ?insert: EitherType<String, Text>}, EitherType<ChangeSet, Array<ChangeSpec>>>;

/**
A change set represents a group of modifications to a document. It
stores the document length, and can only be applied to documents
with exactly that length.
*/
extern class ChangeSet extends ChangeDesc {
    private function new();

    /**
    Apply the changes to a document, returning the modified
    document.
    */
    function apply(doc: Text): Text;

    function mapDesc(other: ChangeDesc, ?before: Bool): ChangeDesc;

    /**
    Given the document as it existed _before_ the changes, return a
    change set that represents the inverse of this set, which could
    be used to go from the document created by the changes back to
    the document as it existed before the changes.
    */
    function invert(doc: Text): ChangeSet;

    /**
    Combine two subsequent change sets into a single set. `other`
    must start in the document produced by `this`. If `this` goes
    `docA` → `docB` and `other` represents `docB` → `docC`, the
    returned value will represent the change `docA` → `docC`.
    */
    function compose(other: ChangeSet): ChangeSet;

    /**
    Given another change set starting in the same document, maps this
    change set over the other, producing a new change set that can be
    applied to the document produced by applying `other`. When
    `before` is `true`, order changes as if `this` comes before
    `other`, otherwise (the default) treat `other` as coming first.

    Given two changes `A` and `B`, `A.compose(B.map(A))` and
    `B.compose(A.map(B, true))` will produce the same document. This
    provides a basic form of [operational
    transformation](https://en.wikipedia.org/wiki/Operational_transformation),
    and can be used for collaborative editing.
    */
    function map(other: ChangeDesc, ?before: Bool): ChangeSet;

    /**
    Iterate over the changed ranges in the document, calling `f` for
    each, with the range in the original document (`fromA`-`toA`)
    and the range that replaces it in the new document
    (`fromB`-`toB`).

    When `individual` is true, adjacent changes are reported
    separately.
    */
    function iterChanges(f: (fromA: Int, toA: Int, fromB: Int, toB: Int, inserted: Text) -> Void, ?individual: Bool): Void;

    /**
    Get a [change description](https://codemirror.net/6/docs/ref/#state.ChangeDesc) for this change
    set.
    */
    final desc: ChangeDesc;

    /**
    Serialize this change set to a JSON-representable value.
    */
    function toJSON(): Dynamic;

    /**
    Create a change set for the given changes, for a document of the
    given length, using `lineSep` as line separator.
    */
    static function of(changes: ChangeSpec, length: Int, ?lineSep: String): ChangeSet;

    /**
    Create an empty changeset of the given length.
    */
    static function empty(length: Int): ChangeSet;

    /**
    Create a changeset from its JSON representation (as produced by
    [`toJSON`](https://codemirror.net/6/docs/ref/#state.ChangeSet.toJSON).
    */
    static function fromJSON(json: Dynamic): ChangeSet;
}
