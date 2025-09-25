package codemirror;

typedef StateFieldSpec<Value> = {
    /**
    Creates the initial value for the field when a state is created.
    */
    var create: (state: EditorState) -> Value;
    /**
    Compute a new value from the field's previous value and a
    [transaction](https://codemirror.net/6/docs/ref/#state.Transaction).
    */
    var update: (value: Value, transaction: Transaction) -> Value;

    /**
    Compare two values of the field, returning `true` when they are
    the same. This is used to avoid recomputing facets that depend
    on the field when its value did not change. Defaults to using
    `===`.
    */
    var ?compare: (a: Value, b: Value) -> Bool;

    /**
    Provide extensions based on this field. The given function will
    be called once with the initialized field. It will usually want
    to call some facet's [`from`](https://codemirror.net/6/docs/ref/#state.Facet.from) method to
    create facet inputs from this field, but can also return other
    extensions that should be enabled when the field is present in a
    configuration.
    */
    var ?provide: (field: StateField<Value>) -> Extension;

    /**
    A function used to serialize this field's content to JSON. Only
    necessary when this field is included in the argument to
    [`EditorState.toJSON`](https://codemirror.net/6/docs/ref/#state.EditorState.toJSON).
    */
    var ?toJSON: (value: Value, state: EditorState) -> Dynamic;

    /**
    A function that deserializes the JSON representation of this
    field's content.
    */
    var ?fromJSON: (json: Dynamic, state: EditorState) -> Value;
}

/**
Fields can store additional information in an editor state, and
keep it in sync with the rest of the state.
*/
extern class StateField<Value> {
    private function new();

    /**
    Define a state field.
    */
    static function define<Value>(config: StateFieldSpec<Value>): StateField<Value>;

    /**
    Returns an extension that enables this field and overrides the
    way it is initialized. Can be useful when you need to provide a
    non-default starting value for the field.
    */
    function init(create: (state: EditorState) -> Value): Extension;

    /**
    State field instances can be used as
    [`Extension`](https://codemirror.net/6/docs/ref/#state.Extension) values to enable the field in a
    given state.
    */
    final extension: Extension;
}
