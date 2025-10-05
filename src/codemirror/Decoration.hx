package codemirror;

import haxe.DynamicAccess;
import codemirror.Range.RangeValue;
import codemirror.Range.RangeSet;
import haxe.extern.EitherType;

/**
A decoration set represents a collection of decorated ranges,
organized for efficient access and mapping. See
[`RangeSet`](https://codemirror.net/6/docs/ref/#state.RangeSet) for its methods.
*/
typedef DecorationSet = RangeSet<Decoration>;

/**
A decoration provides information on how to draw or style a piece
of content. You'll usually use it wrapped in a
[`Range`](https://codemirror.net/6/docs/ref/#state.Range), which adds a start and end position.
@nonabstract
*/
extern abstract class Decoration extends RangeValue {
    /**
    The config object used to create this decoration. You can
    include additional properties in there to store metadata about
    your decoration.
    */
    final spec: Dynamic;

    function new(startSide: Int, endSide: Int, widget: Null<WidgetType>,
        /**
        The config object used to create this decoration. You can
        include additional properties in there to store metadata about
        your decoration.
        */
        spec: Dynamic);

    abstract function eq(other: Decoration): Bool;

    /**
    Create a mark decoration, which influences the styling of the
    content in its range. Nested mark decorations will cause nested
    DOM elements to be created. Nesting order is determined by
    precedence of the [facet](https://codemirror.net/6/docs/ref/#view.EditorView^decorations), with
    the higher-precedence decorations creating the inner DOM nodes.
    Such elements are split on line boundaries and on the boundaries
    of lower-precedence decorations.
    */
    static function mark(spec: MarkDecorationSpec): Decoration;

    /**
    Create a widget decoration, which displays a DOM element at the
    given position.
    */
    static function widget(spec: WidgetDecorationSpec): Decoration;

    /**
    Create a replace decoration which replaces the given range with
    a widget, or simply hides it.
    */
    static function replace(spec: ReplaceDecorationSpec): Decoration;

    /**
    Create a line decoration, which can add DOM attributes to the
    line starting at the given position.
    */
    static function line(spec: LineDecorationSpec): Decoration;

    /**
    Build a [`DecorationSet`](https://codemirror.net/6/docs/ref/#view.DecorationSet) from the given
    decorated range or ranges. If the ranges aren't already sorted,
    pass `true` for `sort` to make the library sort them for you.
    */
    static function set(of: EitherType<Range<Decoration>, Array<Range<Decoration>>>, ?sort: Bool): DecorationSet;

    /** The empty set of decorations. */
    static final none: DecorationSet;
}

class SpecBase {
    public function new(props: Null<Dynamic> = null) {
        if (props != null) {
            for (field in Reflect.fields(props)) {
                Reflect.setField(this, field, Reflect.field(props, field));
            }
        }
    }
}

/**
Used to indicate [text direction](https://codemirror.net/6/docs/ref/#view.EditorView.textDirection).
*/
enum abstract Direction(Int) { var LTR = 0; var RTL = 1; }

class MarkDecorationSpec extends SpecBase {
    /**
    Whether the mark covers its start and end position or not. This
    influences whether content inserted at those positions becomes
    part of the mark. Defaults to false.
    */
    public var inclusive: Null<Bool>;

    /**
    Specify whether the start position of the marked range should be
    inclusive. Overrides `inclusive`, when both are present.
    */
    public var inclusiveStart: Null<Bool>;

    /** Whether the end should be inclusive. */
    public var inclusiveEnd: Null<Bool>;

    /** Add attributes to the DOM elements that hold the text in the marked range. */
    public var attributes: Null<Dynamic<String>>;

    /** Shorthand for `{attributes: {class: value}}`. */
    @:native("class") public var class_: Null<String>;

    /**
    Add a wrapping element around the text in the marked range. Note
    that there will not necessarily be a single element covering the
    entire range—other decorations with lower precedence might split
    this one if they partially overlap it, and line breaks always
    end decoration elements.
    */
    public var tagName: Null<String>;

    /**
    When using sets of decorations in
    [`bidiIsolatedRanges`](https://codemirror.net/6/docs/ref/##view.EditorView^bidiIsolatedRanges),
    this property provides the direction of the isolates.
    */
    public var bidiIsolate: Null<Direction>;

    public function new(props: Null<Dynamic> = null) {
        super(props);
    }
}

class WidgetDecorationSpec extends SpecBase {
    /** The type of widget to draw here. */
    public var widget: WidgetType;

    /**
    Which side of the given position the widget is on. When this is
    positive, the widget will be drawn after the cursor if the
    cursor is on the same position. Otherwise, it'll be drawn before
    it. When multiple widgets sit at the same position, their `side`
    values will determine their ordering—those with a lower value
    come first. Defaults to 0. May not be more than 10000 or less
    than -10000.
    */
    public var side: Null<Int>;

    /**
    By default, to avoid unintended mixing of block and inline
    widgets, block widgets with a positive `side` are always drawn
    after all inline widgets at that position, and those with a
    non-positive side before inline widgets. Setting this option to
    `true` for a block widget will turn this off and cause it to be
    rendered between the inline widgets, ordered by `side`.
    */
    public var inlineOrder: Null<Bool>;

    /**
    Determines whether this is a block widgets, which will be drawn
    between lines, or an inline widget (the default) which is drawn
    between the surrounding text.

    Note that block-level decorations should not have vertical
    margins, and if you dynamically change their height, you should
    make sure to call
    [`requestMeasure`](https://codemirror.net/6/docs/ref/#view.EditorView.requestMeasure), so that the
    editor can update its information about its vertical layout.
    */
    public var block: Null<Bool>;

    public function new(widgetType: WidgetType, props: Null<Dynamic> = null) {
        this.widget = widgetType;
        super(props);
    }
}

class ReplaceDecorationSpec extends SpecBase {
    /** An optional widget to draw in the place of the replaced content. */
    public var widget: Null<WidgetType>;

    /**
    Whether this range covers the positions on its sides. This
    influences whether new content becomes part of the range and
    whether the cursor can be drawn on its sides. Defaults to false
    for inline replacements, and true for block replacements.
    */
    public var inclusive: Null<Bool>;

    /** Set inclusivity at the start. */
    public var inclusiveStart: Null<Bool>;

    /** Set inclusivity at the end. */
    public var inclusiveEnd: Null<Bool>;

    /** Whether this is a block-level decoration. Defaults to false. */
    public var block: Null<Bool>;

    public function new(props: Null<Dynamic> = null) {
        super(props);
    }
}

class LineDecorationSpec extends SpecBase {
    /** DOM attributes to add to the element wrapping the line. */
    public var attributes: Null<Dynamic<String>>;

    /** Shorthand for `{attributes: {class: value}}`. */
    @:native("class") public var class_: Null<String>;

    public function new(props: Null<Dynamic> = null) {
        super(props);
    }
}
