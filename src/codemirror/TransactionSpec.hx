package codemirror;

import codemirror.ChangeSet.ChangeSpec;
import haxe.extern.EitherType;

/**
Describes a [transaction](https://codemirror.net/6/docs/ref/#state.Transaction) when calling the
[`EditorState.update`](https://codemirror.net/6/docs/ref/#state.EditorState.update) method.
*/
typedef TransactionSpec = {
    /**
    The changes to the document made by this transaction.
    */
    var ?changes: ChangeSpec;

    /**
    When set, this transaction explicitly updates the selection.
    Offsets in this selection should refer to the document as it is
    _after_ the transaction.
    */
    var ?selection: EitherType<EditorSelection, { anchor: Int, ?head: Int }>;

    /**
    Attach [state effects](https://codemirror.net/6/docs/ref/#state.StateEffect) to this transaction.
    Again, when they contain positions and this same spec makes
    changes, those positions should refer to positions in the
    updated document.
    */
    var ?effects: EitherType<StateEffect<Any>, Array<StateEffect<Any>>>;

    /**
    Set [annotations](https://codemirror.net/6/docs/ref/#state.Annotation) for this transaction.
    */
    var ?annotations: EitherType<Annotation<Any>, Array<Annotation<Any>>>;

    /**
    Shorthand for `annotations:` [`Transaction.userEvent`](https://codemirror.net/6/docs/ref/#state.Transaction^userEvent)`.of(...)`.
    */
    var ?userEvent: String;

    /**
    When set to `true`, the transaction is marked as needing to
    scroll the current selection into view.
    */
    var ?scrollIntoView: Bool;

    /**
    By default, transactions can be modified by [change
    filters](https://codemirror.net/6/docs/ref/#state.EditorState^changeFilter) and [transaction
    filters](https://codemirror.net/6/docs/ref/#state.EditorState^transactionFilter). You can set this
    to `false` to disable that. This can be necessary for
    transactions that, for example, include annotations that must be
    kept consistent with their changes.
    */
    var ?filter: Bool;

    /**
    Normally, when multiple specs are combined (for example by
    [`EditorState.update`](https://codemirror.net/6/docs/ref/#state.EditorState.update)), the
    positions in `changes` are taken to refer to the document
    positions in the initial document. When a spec has `sequental`
    set to true, its positions will be taken to refer to the
    document created by the specs before it instead.
    */
    var ?sequential: Bool;
}
