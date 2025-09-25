package codemirror;

import haxe.extern.EitherType;
import js.html.DocumentFragment;
import js.html.DOMElement;
import js.html.Document;
import js.html.ShadowRoot;

/**
The type of object given to the [`EditorView`](https://codemirror.net/6/docs/ref/#view.EditorView)
constructor.
*/
typedef EditorViewConfig = EditorStateConfig & {
    /**
    The view's initial state. If not given, a new state is created
    by passing this configuration object to
    [`EditorState.create`](https://codemirror.net/6/docs/ref/#state.EditorState^create), using its
    `doc`, `selection`, and `extensions` field (if provided).
    */
    var ?state: EditorState;

    /**
    When given, the editor is immediately appended to the given
    element on creation. (Otherwise, you'll have to place the view's
    [`dom`](https://codemirror.net/6/docs/ref/#view.EditorView.dom) element in the document yourself.)
    */
    var ?parent: EitherType<DOMElement, DocumentFragment>;

    /**
    If the view is going to be mounted in a shadow root or document
    other than the one held by the global variable `document` (the
    default), you should pass it here. If you provide `parent`, but
    not this option, the editor will automatically look up a root
    from the parent.
    */
    var ?root: EitherType<Document, ShadowRoot>;

    /**
    Override the way transactions are
    [dispatched](https://codemirror.net/6/docs/ref/#view.EditorView.dispatch) for this editor view.
    Your implementation, if provided, should probably call the
    view's [`update` method](https://codemirror.net/6/docs/ref/#view.EditorView.update).
    */
    var ?dispatchTransactions: (trs: Array<Transaction>, view: EditorView) -> Void;

    // /**
    // **Deprecated** single-transaction version of
    // `dispatchTransactions`. Will force transactions to be dispatched
    // one at a time when used.
    // */
    // dispatch?: (tr: Transaction, view: EditorView) => void;
}
