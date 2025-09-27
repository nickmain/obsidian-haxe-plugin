package codemirror;

import codemirror.EditorState.StateCommand;
import js.html.Node;
import js.lib.Promise;
import js.lib.RegExp;
import haxe.extern.EitherType;

/**
The function signature for a completion source. Such a function
may return its [result](https://codemirror.net/6/docs/ref/#autocomplete.CompletionResult)
synchronously or as a promise. Returning null indicates no completions are available.
*/
typedef CompletionSource = (context: CompletionContext) -> Null<EitherType<CompletionResult, Promise<Null<CompletionResult>>>>;

@:jsRequire("@codemirror/autocomplete")
extern class Autocomplete {
    /**
    Given a a fixed array of options, return an autocompleter that
    completes them.
    */
    static function completeFromList(list: Array<EitherType<String, Completion>>): CompletionSource;

    /**
    Wrap the given completion source so that it will only fire when the
    cursor is in a syntax node with one of the given names.
    */
    static function ifIn(nodes: Array<String>, source: CompletionSource): CompletionSource;
    /**
    Wrap the given completion source so that it will not fire when the
    cursor is in a syntax node with one of the given names.
    */
    static function ifNotIn(nodes: Array<String>, source: CompletionSource): CompletionSource;

    /**
    Convert a snippet template to a function that can apply it.
    Snippets are written using syntax like this:

        "for (let ${index} = 0; ${index} < ${end}; ${index}++) {\n\t${}\n}"

    Each `${}` placeholder (you may also use `#{}`) indicates a field
    that the user can fill in. Its name, if any, will be the default
    content for the field.

    When the snippet is activated by calling the returned function,
    the code is inserted at the given position. Newlines in the
    template are indented by the indentation of the start line, plus
    one [indent unit](https://codemirror.net/6/docs/ref/#language.indentUnit) per tab character after
    the newline.

    On activation, (all instances of) the first field are selected.
    The user can move between fields with Tab and Shift-Tab as long as
    the fields are active. Moving to the last field or moving the
    cursor out of the current field deactivates the fields.

    The order of fields defaults to textual order, but you can add
    numbers to placeholders (`${1}` or `${1:defaultText}`) to provide
    a custom order.
    */
    static function snippet(template: String): (editor: {
        var state: EditorState;
        var dispatch: (tr: Transaction) -> Void;
    }, _completion: Completion, from: Int, to: Int) -> Void;

    /** A command that clears the active snippet, if any. */
    static final clearSnippet: StateCommand;

    /** Move to the next snippet field, if available. */
    static final nextSnippetField: StateCommand;

    /** Move to the previous snippet field, if available. */
    static final prevSnippetField: StateCommand;

    /**
    A facet that can be used to configure the key bindings used by
    snippets. The default binds Tab to
    [`nextSnippetField`](https://codemirror.net/6/docs/ref/#autocomplete.nextSnippetField), Shift-Tab to
    [`prevSnippetField`](https://codemirror.net/6/docs/ref/#autocomplete.prevSnippetField), and Escape
    to [`clearSnippet`](https://codemirror.net/6/docs/ref/#autocomplete.clearSnippet).
    */
    static final snippetKeymap: Facet<Array<KeyBinding>, Array<KeyBinding>>;

    /**
    Create a completion from a snippet. Returns an object with the
    properties from `completion`, plus an `apply` function that
    applies the snippet.
    */
    static function snippetCompletion(template: String, completion: Completion): Completion;

    /**
    Returns a command that moves the completion selection forward or
    backward by the given amount.
    */
    static function moveCompletionSelection(forward: Bool, ?by: MoveCompletionSelectionStep): Command;

    /**
    Accept the current completion.
    */
    static final acceptCompletion: Command;

    /**
    Explicitly start autocompletion.
    */
    static final startCompletion: Command;

    /**
    Close the currently active completion.
    */
    static final closeCompletion: Command;

    /**
    A completion source that will scan the document for words (using a
    [character categorizer](https://codemirror.net/6/docs/ref/#state.EditorState.charCategorizer)), and
    return those as completions.
    */
    static final completeAnyWord: CompletionSource;

    /**
    Returns an extension that enables autocompletion.
    */
    static function autocompletion(?config: CompletionConfig): Extension;

    /**
    Basic keybindings for autocompletion.

    - Ctrl-Space: [`startCompletion`](https://codemirror.net/6/docs/ref/#autocomplete.startCompletion)
    - Escape: [`closeCompletion`](https://codemirror.net/6/docs/ref/#autocomplete.closeCompletion)
    - ArrowDown: [`moveCompletionSelection`](https://codemirror.net/6/docs/ref/#autocomplete.moveCompletionSelection)`(true)`
    - ArrowUp: [`moveCompletionSelection`](https://codemirror.net/6/docs/ref/#autocomplete.moveCompletionSelection)`(false)`
    - PageDown: [`moveCompletionSelection`](https://codemirror.net/6/docs/ref/#autocomplete.moveCompletionSelection)`(true, "page")`
    - PageDown: [`moveCompletionSelection`](https://codemirror.net/6/docs/ref/#autocomplete.moveCompletionSelection)`(true, "page")`
    - Enter: [`acceptCompletion`](https://codemirror.net/6/docs/ref/#autocomplete.acceptCompletion)
    */
    static final completionKeymap: Array<KeyBinding>;

    /**
    Get the current completion status. When completions are available,
    this will return `"active"`. When completions are pending (in the
    process of being queried), this returns `"pending"`. Otherwise, it
    returns `null`.
    */
    static function completionStatus(state: EditorState): Null<CompletionStatusResult>;

    /**
    Returns the available completions as an array.
    */
    static function currentCompletions(state: EditorState): Array<Completion>;

}

enum abstract CompletionStatusResult(String) {
    var Active ="active"; var Pending = "pending";
}

enum abstract MoveCompletionSelectionStep(String) {
    var Option = "option"; var Page = "page";
}

class CompletionConfig {
    /**
    When enabled (defaults to true), autocompletion will start
    whenever the user types something that can be completed.
    */
    public var activateOnTyping: Null<Bool>;

    /**
    Override the completion sources used. By default, they will be
    taken from the `"autocomplete"` [language
    data](https://codemirror.net/6/docs/ref/#state.EditorState.languageDataAt) (which should hold
    [completion sources](https://codemirror.net/6/docs/ref/#autocomplete.CompletionSource)).
    */
    @:native("override") public var override_: Null<Array<CompletionSource>>;

    /**
    The maximum number of options to render to the DOM.
    */
    public var maxRenderedOptions: Null<Int>;

    /**
    Set this to false to disable the [default completion
    keymap](https://codemirror.net/6/docs/ref/#autocomplete.completionKeymap). (This requires you to
    add bindings to control completion yourself. The bindings should
    probably have a higher precedence than other bindings for the
    same keys.)
    */
    public var defaultKeymap: Null<Bool>;

    public function new(activateOnTyping: Null<Bool>,
                        override_: Null<Array<CompletionSource>>,
                        maxRenderedOptions: Null<Int>,
                        defaultKeymap: Null<Bool>) {
        this.activateOnTyping = activateOnTyping;
        this.override_ = override_;
        this.maxRenderedOptions = maxRenderedOptions;
        this.defaultKeymap = defaultKeymap;
    }
}

/**
Objects type used to represent individual completions.
*/
typedef Completion = {
    /**
    The label to show in the completion picker. This is what input
    is matched agains to determine whether a completion matches (and
    how well it matches).
    */
    var label: String;

    /**
    An optional short piece of information to show (with a different
    style) after the label.
    */
    var ?detail: String;

    /**
    Additional info to show when the completion is selected. Can be
    a plain string or a function that'll render the DOM structure to
    show when invoked.
    */
    var ?info: EitherType<String, ((completion: Completion) -> EitherType<Node, Promise<Node>>)>;

    /**
    How to apply the completion. The default is to replace it with
    its [label](https://codemirror.net/6/docs/ref/#autocomplete.Completion.label). When this holds a
    string, the completion range is replaced by that string. When it
    is a function, that function is called to perform the
    completion.
    */
    var ?apply: EitherType<String, ((view: EditorView, completion: Completion, from: Int, to: Int) -> Void)>;

    /**
    The type of the completion. This is used to pick an icon to show
    for the completion. Icons are styled with a CSS class created by
    appending the type name to `"cm-completionIcon-"`. You can
    define or restyle icons by defining these selectors. The base
    library defines simple icons for `class`, `constant`, `enum`,
    `function`, `interface`, `keyword`, `method`, `namespace`,
    `property`, `text`, `type`, and `variable`.

    Multiple types can be provided by separating them with spaces.
    */
    var ?type: String;

    /**
    When given, should be a number from -99 to 99 that adjusts how
    this completion is ranked compared to other completions that
    match the input as well as this one. A negative number moves it
    down the list, a positive number moves it up.
    */
    var ?boost: Int;
}

/** Interface for objects returned by completion sources. */
typedef CompletionResult = {
    /**
    The start of the range that is being completed.
    */
    var from: Int;
    /**
    The end of the range that is being completed. Defaults to the
    main cursor position.
    */
    var ?to: Int;

    /**
    The completions returned. These don't have to be compared with
    the input by the source—the autocompletion system will do its
    own matching (against the text between `from` and `to`) and
    sorting.
    */
    var options: Array<Completion>;

    /**
    When given, further input that causes the part of the document
    between ([mapped](https://codemirror.net/6/docs/ref/#state.ChangeDesc.mapPos)) `from` and `to` to
    match this regular expression will not query the completion
    source again, but continue with this list of options. This can
    help a lot with responsiveness, since it allows the completion
    list to be updated synchronously.
    */
    var ?span: RegExp;

    /**
    By default, the library filters and scores completions. Set
    `filter` to `false` to disable this, and cause your completions
    to all be included, in the order they were given. When there are
    other sources, unfiltered completions appear at the top of the
    list of completions. `span` must not be given `filter` is
    `false`, because it only works when filtering.
    */
    var ?filter: Bool;
}

/**
An instance of this is passed to completion source functions.
*/
@:jsRequire("@codemirror/autocomplete", "CompletionContext")
extern class CompletionContext {
    /**
    The editor state that the completion happens in.
    */
    final state: EditorState;

    /**
    The position at which the completion is happening.
    */
    final pos: Int;

    /**
    Indicates whether completion was activated explicitly, or
    implicitly by typing. The usual way to respond to this is to
    only return completions when either there is part of a
    completable entity before the cursor, or `explicit` is true.
    */
    final explicit: Bool;

    /**
    Create a new completion context. (Mostly useful for testing
    completion sources—in the editor, the extension will create
    these for you.)
    */

    function new(
        /** The editor state that the completion happens in. */
        state: EditorState,

        /** The position at which the completion is happening. */
        pos: Int,

        /**
        Indicates whether completion was activated explicitly, or
        implicitly by typing. The usual way to respond to this is to
        only return completions when either there is part of a
        completable entity before the cursor, or `explicit` is true.
        */
        explicit: Bool
    );

    /**
    Get the extent, content, and (if there is a token) type of the
    token before `this.pos`.
    */
    function tokenBefore(types: Array<String>): Null<{
        var from: Int;
        var to: Int;
        var text: String;
        var type: Dynamic; // _lezer_common.NodeType;
    }>;

    /**
    Get the match of the given expression directly before the
    cursor.
    */
    function matchBefore(expr: RegExp): Null<{
        var from: Int;
        var to: Int;
        var text: String;
    }>;

    /**
    Yields true when the query has been aborted. Can be useful in
    asynchronous queries to avoid doing work that will be ignored.
    */
    final aborted: Bool;

    /**
    Allows you to register abort handlers, which will be called when
    the query is [aborted](https://codemirror.net/6/docs/ref/#autocomplete.CompletionContext.aborted).
    */
    function addEventListener(type: AboreEventType, listener: () -> Void): Void;
}

enum abstract AboreEventType(String) { var Abort = "abort"; }
