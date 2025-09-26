package codemirror;

/**
View [plugins](https://codemirror.net/6/docs/ref/#view.ViewPlugin) are given instances of this
class, which describe what happened, whenever the view is updated.
*/
extern class ViewUpdate {
    /**
    The editor view that the update is associated with.
    */
    final view: EditorView;

    /**
    The new editor state.
    */
    final state: EditorState;

    /**
    The transactions involved in the update. May be empty.
    */
    final transactions: Array<Transaction>;

    /**
    The changes made to the document by this update.
    */
    final changes: ChangeSet;

    /**
    The previous editor state.
    */
    final startState: EditorState;

    private function new();

    /**
    Tells you whether the [viewport](https://codemirror.net/6/docs/ref/#view.EditorView.viewport) or
    [visible ranges](https://codemirror.net/6/docs/ref/#view.EditorView.visibleRanges) changed in this
    update.
    */
    final viewportChanged: Bool;
    
    /**
    Indicates whether the height of a block element in the editor
    changed in this update.
    */
    final heightChanged: Bool;

    /**
    Returns true when the document was modified or the size of the
    editor, or elements within the editor, changed.
    */
    final geometryChanged: Bool;

    /**
    True when this update indicates a focus change.
    */
    final focusChanged: Bool;

    /**
    Whether the document changed in this update.
    */
    final docChanged: Bool;

    /**
    Whether the selection was explicitly set in this update.
    */
    final selectionSet: Bool;
}
