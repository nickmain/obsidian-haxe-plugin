package codemirror;

import haxe.extern.EitherType;

/** The different types of blocks that can occur in an editor view. */
enum abstract BlockType(Int) {
    /** A line of text. */
    var Text = 0;

    /** A block widget associated with the position after it. */
    var WidgetBefore = 1;

    /** A block widget associated with the position before it. */
    var WidgetAfter = 2;

    /** A block widget [replacing](https://codemirror.net/6/docs/ref/#view.Decoration^replace) a range of content. */
    var WidgetRange = 3;
}

/** Record used to represent information about a block-level element in the editor view. */
extern class BlockInfo {
    /** The start of the element in the document.*/
    final from: Int;

    /** The length of the element. */
    final length: Int;

    /** The top position of the element (relative to the top of the document). */
    final top: Int;

    /** Its height. */
    final height: Int;

    /** The type of element this is. When querying lines, this may be an array of all the blocks that make up the line. */
    final type: EitherType<BlockType, Array<BlockInfo>>;

    /** The end of the element as a document position. */
    final to: Int;

    /** The bottom position of the element.*/
    final  bottom: Int;

    /** If this is a widget block, this will return the widget associated with it. */
    final  widget: Null<WidgetType>;

    /** If this is a textblock, this holds the number of line breaks that appear in widgets inside the block. */
    final  widgetLineBreaks: Int;
}
