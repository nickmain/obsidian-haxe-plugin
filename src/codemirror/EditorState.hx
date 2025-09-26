package codemirror;

import codemirror.ChangeSet.ChangeSpec;
import haxe.extern.EitherType;

/**
The editor state class is a persistent (immutable) data structure.
To update a state, you [create](https://codemirror.net/6/docs/ref/#state.EditorState.update) a
[transaction](https://codemirror.net/6/docs/ref/#state.Transaction), which produces a _new_ state
instance, without modifying the original object.

As such, _never_ mutate properties of a state directly. That'll
just break things.
*/
@:jsRequire("@codemirror/state", "EditorState")
extern class EditorState {
    /** The current document. */
    final doc: Text;

    /** The current selection. */
    final selection: EditorSelection;

    private function new();

    /**
    Retrieve the value of a [state field](https://codemirror.net/6/docs/ref/#state.StateField). Throws
    an error when the state doesn't have that field, unless you pass
    `false` as second parameter.
    */
    @:overload(function<T>(field: StateField<T>): T {})
    function field<T>(field: StateField<T>, require: Bool): Null<T>;

    /**
    Create a [transaction](https://codemirror.net/6/docs/ref/#state.Transaction) that updates this
    state. Any number of [transaction specs](https://codemirror.net/6/docs/ref/#state.TransactionSpec)
    can be passed. Unless
    [`sequential`](https://codemirror.net/6/docs/ref/#state.TransactionSpec.sequential) is set, the
    [changes](https://codemirror.net/6/docs/ref/#state.TransactionSpec.changes) (if any) of each spec
    are assumed to start in the _current_ document (not the document
    produced by previous specs), and its
    [selection](https://codemirror.net/6/docs/ref/#state.TransactionSpec.selection) and
    [effects](https://codemirror.net/6/docs/ref/#state.TransactionSpec.effects) are assumed to refer
    to the document created by its _own_ changes. The resulting
    transaction contains the combined effect of all the different
    specs. For [selection](https://codemirror.net/6/docs/ref/#state.TransactionSpec.selection), later
    specs take precedence over earlier ones.
    */
    function update(specs: Array<TransactionSpec>): Transaction;

    /**
    Create a [transaction spec](https://codemirror.net/6/docs/ref/#state.TransactionSpec) that
    replaces every selection range with the given content.
    */
    function replaceSelection(text: EitherType<String, Text>): TransactionSpec;

    /**
    Create a set of changes and a new selection by running the given
    function for each range in the active selection. The function
    can return an optional set of changes (in the coordinate space
    of the start document), plus an updated range (in the coordinate
    space of the document produced by the call's own changes). This
    method will merge all the changes and ranges into a single
    changeset and selection, and return it as a [transaction
    spec](https://codemirror.net/6/docs/ref/#state.TransactionSpec), which can be passed to
    [`update`](https://codemirror.net/6/docs/ref/#state.EditorState.update).
    */
    function changeByRange(f: (range: SelectionRange) -> {
        range: SelectionRange,
        ?changes: ChangeSpec,
        ?effects: EitherType<StateEffect<Any>, Array<StateEffect<Any>>>
    }): {
        changes: ChangeSet,
        selection: EditorSelection,
        effects: Array<StateEffect<Any>>
    };

    /**
    Create a [change set](https://codemirror.net/6/docs/ref/#state.ChangeSet) from the given change
    description, taking the state's document length and line
    separator into account.
    */
    function changes(?spec: ChangeSpec): ChangeSet;

    /**
    Using the state's [line separator](https://codemirror.net/6/docs/ref/#state.EditorState^lineSeparator), create a
    [`Text`](https://codemirror.net/6/docs/ref/#state.Text) instance from the given string.
    */
    function toText(string: String): Text;

    /**
    Return the given range of the document as a string.
    */
    function sliceDoc(?from: Int, ?to: Int): String;

    // /**
    // Get the value of a state [facet](https://codemirror.net/6/docs/ref/#state.Facet).
    // */
    // facet<Output>(facet: Facet<any, Output>): Output;

    // /**
    // Convert this state to a JSON-serializable object. When custom
    // fields should be serialized, you can pass them in as an object
    // mapping property names (in the resulting object, which should
    // not use `doc` or `selection`) to fields.
    // */
    // toJSON(fields?: {
    //     [prop: string]: StateField<any>;
    // }): any;

    // /**
    // Deserialize a state from its JSON representation. When custom
    // fields should be deserialized, pass the same object you passed
    // to [`toJSON`](https://codemirror.net/6/docs/ref/#state.EditorState.toJSON) when serializing as
    // third argument.
    // */
    // static fromJSON(json: any, config?: EditorStateConfig, fields?: {
    //     [prop: string]: StateField<any>;
    // }): EditorState;

    /**
    Create a new state. You'll usually only need this when
    initializing an editor—updated states are created by applying
    transactions.
    */
    static function create(?config: EditorStateConfig): EditorState;

    // /**
    // A facet that, when enabled, causes the editor to allow multiple
    // ranges to be selected. Be careful though, because by default the
    // editor relies on the native DOM selection, which cannot handle
    // multiple selections. An extension like
    // [`drawSelection`](https://codemirror.net/6/docs/ref/#view.drawSelection) can be used to make
    // secondary selections visible to the user.
    // */
    // static allowMultipleSelections: Facet<boolean, boolean>;

    // /**
    // Configures the tab size to use in this state. The first
    // (highest-precedence) value of the facet is used. If no value is
    // given, this defaults to 4.
    // */
    // static tabSize: Facet<number, number>;

    // /**
    // The size (in columns) of a tab in the document, determined by
    // the [`tabSize`](https://codemirror.net/6/docs/ref/#state.EditorState^tabSize) facet.
    // */
    // get tabSize(): number;

    // /**
    // The line separator to use. By default, any of `"\n"`, `"\r\n"`
    // and `"\r"` is treated as a separator when splitting lines, and
    // lines are joined with `"\n"`.
    //
    // When you configure a value here, only that precise separator
    // will be used, allowing you to round-trip documents through the
    // editor without normalizing line separators.
    // */
    // static lineSeparator: Facet<string, string | undefined>;

    // /**
    // Get the proper [line-break](https://codemirror.net/6/docs/ref/#state.EditorState^lineSeparator)
    // string for this state.
    // */
    // get lineBreak(): string;

    // /**
    // This facet controls the value of the
    // [`readOnly`](https://codemirror.net/6/docs/ref/#state.EditorState.readOnly) getter, which is
    // consulted by commands and extensions that implement editing
    // functionality to determine whether they should apply. It
    // defaults to false, but when its highest-precedence value is
    // `true`, such functionality disables itself.
    //
    // Not to be confused with
    // [`EditorView.editable`](https://codemirror.net/6/docs/ref/#view.EditorView^editable), which
    // controls whether the editor's DOM is set to be editable (and
    // thus focusable).
    // */
    // static readOnly: Facet<boolean, boolean>;

    // /**
    // Returns true when the editor is
    // [configured](https://codemirror.net/6/docs/ref/#state.EditorState^readOnly) to be read-only.
    // */
    // get readOnly(): boolean;

    // /**
    // Registers translation phrases. The
    // [`phrase`](https://codemirror.net/6/docs/ref/#state.EditorState.phrase) method will look through
    // all objects registered with this facet to find translations for
    // its argument.
    // */
    // static phrases: Facet<{
    //     [key: string]: string;
    // }, readonly {
    //     [key: string]: string;
    // }[]>;

    // /**
    // Look up a translation for the given phrase (via the
    // [`phrases`](https://codemirror.net/6/docs/ref/#state.EditorState^phrases) facet), or return the
    // original string if no translation is found.
    //
    // If additional arguments are passed, they will be inserted in
    // place of markers like `$1` (for the first value) and `$2`, etc.
    // A single `$` is equivalent to `$1`, and `$$` will produce a
    // literal dollar sign.
    // */
    // phrase(phrase: string, ...insert: any[]): string;

    // /**
    // A facet used to register [language
    // data](https://codemirror.net/6/docs/ref/#state.EditorState.languageDataAt) providers.
    // */
    // static languageData: Facet<(state: EditorState, pos: number, side: 0 | 1 | -1) => readonly {
    //     [name: string]: any;
    // }[], readonly ((state: EditorState, pos: number, side: 0 | 1 | -1) => readonly {
    //     [name: string]: any;
    // }[])[]>;

    // /**
    // Find the values for a given language data field, provided by the
    // the [`languageData`](https://codemirror.net/6/docs/ref/#state.EditorState^languageData) facet.
    //
    // Examples of language data fields are...
    //
    // - [`"commentTokens"`](https://codemirror.net/6/docs/ref/#commands.CommentTokens) for specifying
    //   comment syntax.
    // - [`"autocomplete"`](https://codemirror.net/6/docs/ref/#autocomplete.autocompletion^config.override)
    //   for providing language-specific completion sources.
    // - [`"wordChars"`](https://codemirror.net/6/docs/ref/#state.EditorState.charCategorizer) for adding
    //   characters that should be considered part of words in this
    //   language.
    // - [`"closeBrackets"`](https://codemirror.net/6/docs/ref/#autocomplete.CloseBracketConfig) controls
    //   bracket closing behavior.
    // */
    // languageDataAt<T>(name: string, pos: number, side?: -1 | 0 | 1): readonly T[];

    // /**
    // Return a function that can categorize strings (expected to
    // represent a single [grapheme cluster](https://codemirror.net/6/docs/ref/#state.findClusterBreak))
    // into one of:
    //
    //  - Word (contains an alphanumeric character or a character
    //    explicitly listed in the local language's `"wordChars"`
    //    language data, which should be a string)
    //  - Space (contains only whitespace)
    //  - Other (anything else)
    // */
    // charCategorizer(at: number): (char: string) => CharCategory;

    // /**
    // Find the word at the given position, meaning the range
    // containing all [word](https://codemirror.net/6/docs/ref/#state.CharCategory.Word) characters
    // around it. If no word characters are adjacent to the position,
    // this returns null.
    // */
    // wordAt(pos: number): SelectionRange | null;

    // /**
    // Facet used to register change filters, which are called for each
    // transaction (unless explicitly
    // [disabled](https://codemirror.net/6/docs/ref/#state.TransactionSpec.filter)), and can suppress
    // part of the transaction's changes.
    //
    // Such a function can return `true` to indicate that it doesn't
    // want to do anything, `false` to completely stop the changes in
    // the transaction, or a set of ranges in which changes should be
    // suppressed. Such ranges are represented as an array of numbers,
    // with each pair of two numbers indicating the start and end of a
    // range. So for example `[10, 20, 100, 110]` suppresses changes
    // between 10 and 20, and between 100 and 110.
    // */
    // static changeFilter: Facet<(tr: Transaction) => boolean | readonly number[], readonly ((tr: Transaction) => boolean | readonly number[])[]>;

    // /**
    // Facet used to register a hook that gets a chance to update or
    // replace transaction specs before they are applied. This will
    // only be applied for transactions that don't have
    // [`filter`](https://codemirror.net/6/docs/ref/#state.TransactionSpec.filter) set to `false`. You
    // can either return a single transaction spec (possibly the input
    // transaction), or an array of specs (which will be combined in
    // the same way as the arguments to
    // [`EditorState.update`](https://codemirror.net/6/docs/ref/#state.EditorState.update)).

    // When possible, it is recommended to avoid accessing
    // [`Transaction.state`](https://codemirror.net/6/docs/ref/#state.Transaction.state) in a filter,
    // since it will force creation of a state that will then be
    // discarded again, if the transaction is actually filtered.
    //
    // (This functionality should be used with care. Indiscriminately
    // modifying transaction is likely to break something or degrade
    // the user experience.)
    // */
    // static transactionFilter: Facet<(tr: Transaction) => TransactionSpec | readonly TransactionSpec[], readonly ((tr: Transaction) => TransactionSpec | readonly TransactionSpec[])[]>;

    // /**
    // This is a more limited form of
    // [`transactionFilter`](https://codemirror.net/6/docs/ref/#state.EditorState^transactionFilter),
    // which can only add
    // [annotations](https://codemirror.net/6/docs/ref/#state.TransactionSpec.annotations) and
    // [effects](https://codemirror.net/6/docs/ref/#state.TransactionSpec.effects). _But_, this type
    // of filter runs even if the transaction has disabled regular
    // [filtering](https://codemirror.net/6/docs/ref/#state.TransactionSpec.filter), making it suitable
    // for effects that don't need to touch the changes or selection,
    // but do want to process every transaction.
    //
    // Extenders run _after_ filters, when both are present.
    // */
    // static transactionExtender: Facet<(tr: Transaction) => Pick<TransactionSpec, "effects" | "annotations"> | null, readonly ((tr: Transaction) => Pick<TransactionSpec, "effects" | "annotations"> | null)[]>;
}
