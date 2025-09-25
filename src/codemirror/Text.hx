package codemirror;

enum abstract IterationDirection(Int) { var Backwards = -1; var Forwards = 1; }

/**
 * A text iterator iterates over a sequence of strings. When
 * iterating over a [`Text`](https://codemirror.net/6/docs/ref/#state.Text) document, result values will
 * either be lines or line breaks.
 */
interface TextIterator {
    /** Retrieve the next string. Optionally skip a given number of positions after the current position. Always returns the object itself. */
    function next(?skip: Int): TextIterator;

    /** The current string. Will be the empty string when the cursor is at its end or `next` hasn't been called on it yet. */
    final value: String;

    /** Whether the end of the iteration has been reached. You should probably check this right after calling `next`. */
    final done: Bool;

    /** Whether the current string represents a line break. */
    final lineBreak: Bool;
}

/**
This type describes a line in the document. It is created
on-demand when lines are [queried](https://codemirror.net/6/docs/ref/#state.Text.lineAt).
*/
typedef Line = {
    /** The position of the start of the line. */
    final from: Int;

    /** The position at the end of the line (_before_ the line break, or at the end of document for the last line). */
    final to: Int;

    /** This line's line number (1-based). */
    final number: Int;

    /** The line's content. */
    final text: String;

    /** The length of the line (not including any line break after it). */
    final length: Int;
}

/** The data structure for documents. */
extern abstract class Text {
    /** The length of the string. */
    final length: Int;

    /** The number of lines in the string (always >= 1). */
    final lines: Int;

    /** Get the line description around the given position. */
    function lineAt(pos: Int): Line;

    /** Get the description for the given (1-based) line number. */
    function line(n: Int): Line;

    /** Replace a range of the text with the given content. */
    function replace(from: Int, to: Int, text: Text): Text;

    /** Append another document to this one. */
    function append(other: Text): Text;

    /** Retrieve the text between the given points. */
    function slice(from: Int, ?to: Int): Text;

    /**
    Retrieve a part of the document as a string
    */
    abstract function sliceString(from: Int, ?to: Int, ?lineSep: String): String;

    /** Test whether this text is equal to another instance. */
    function eq(other: Text): Bool;

    /**
    Iterate over the text. When `dir` is `-1`, iteration happens
    from end to start. This will return lines and the breaks between
    them as separate strings.
    */
    function iter(?dir: IterationDirection): TextIterator;

    /**
    Iterate over a range of the text. When `from` > `to`, the
    iterator will run in reverse.
    */
    function iterRange(from: Int, ?to: Int): TextIterator;

    /**
    Return a cursor that iterates over the given range of lines,
    _without_ returning the line breaks between, and yielding empty
    strings for empty lines.

    When `from` and `to` are given, they should be 1-based line numbers.
    */
    function iterLines(?from: Int, ?to: Int): TextIterator;

    /** Return the document as a string, using newline characters to separate lines. */
    function toString(): String;

    /**
    Convert the document to an array of lines (which can be
    deserialized again via [`Text.of`](https://codemirror.net/6/docs/ref/#state.Text^of)).
    */
    function toJSON(): Array<String>;

    /**
    If this is a branch node, `children` will hold the `Text`
    objects that it is made up of. For leaf nodes, this holds null.
    */
    final children: Null<Array<Text>>;

    // [Symbol.iterator]: () => Iterator<String>;

    /** Create a `Text` instance for the given array of lines. */
    static function of(text: Array<String>): Text;

    /** The empty document. */
    static final empty: Text;
}
