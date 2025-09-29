package codemirror;

/**
Each range is associated with a value, which must inherit from
this class.
*/
extern abstract class RangeValue {
    /**
    Compare this value with another value. Used when comparing
    rangesets. The default implementation compares by identity.
    Unless you are only creating a fixed number of unique instances
    of your value type, it is a good idea to implement this
    properly.
    */
    function eq(other: RangeValue): Bool;
    /**
    The bias value at the start of the range. Determines how the
    range is positioned relative to other ranges starting at this
    position. Defaults to 0.
    */
    var startSide: Int;
    /**
    The bias value at the end of the range. Defaults to 0.
    */
    var endSide: Int;
    /**
    The mode with which the location of the range should be mapped
    when its `from` and `to` are the same, to decide whether a
    change deletes the range. Defaults to `MapMode.TrackDel`.
    */
    var mapMode: MapMode;
    /**
    Determines whether this value marks a point range. Regular
    ranges affect the part of the document they cover, and are
    meaningless when empty. Point ranges have a meaning on their
    own. When non-empty, a point range is treated as atomic and
    shadows any ranges contained in it.
    */
    var point: Bool;
    /**
    Create a [range](https://codemirror.net/6/docs/ref/#state.Range) with this value.
    */
    function range<T>(from: Int, ?to: Int): Range<T>;
}

/**
A range associates a value with a range of positions.
*/
extern class Range<T: RangeValue<T>> {
    /**
    The range's start position.
    */
    final  from: Int;
    /**
    Its end position.
    */
    final to: Int;
    /**
    The value associated with this range.
    */
    final value: T;

    private function new();
}

/**
Collection of methods used when comparing range sets.
*/
interface RangeComparator<T: RangeValue> {
    /**
    Notifies the comparator that a range (in positions in the new
    document) has the given sets of values associated with it, which
    are different in the old (A) and new (B) sets.
    */
    function compareRange(from: Int, to: Int, activeA: Array<T>, activeB: Array<T>): Void;
    /**
    Notification for a changed (or inserted, or deleted) point range.
    */
    function comparePoint(from: Int, to: Int, pointA: Null<T>, pointB: Null<T>): Void;
}

/**
Methods used when iterating over the spans created by a set of
ranges. The entire iterated range will be covered with either
`span` or `point` calls.
*/
interface SpanIterator<T: RangeValue> {
    /**
    Called for any ranges not covered by point decorations. `active`
    holds the values that the range is marked with (and may be
    empty). `openStart` indicates how many of those ranges are open
    (continued) at the start of the span.
    */
    function span(from: Int, to: Int, active: Array<T>, openStart: Int): Void;
    /**
    Called when going over a point decoration. The active range
    decorations that cover the point and have a higher precedence
    are provided in `active`. The open count in `openStart` counts
    the number of those ranges that started before the point and. If
    the point started before the iterated range, `openStart` will be
    `active.length + 1` to signal this.
    */
    function point(from: Int, to: Int, value: T, active: Array<T>, openStart: Int, index: Int): Void;
}

/**
A range cursor is an object that moves to the next range every
time you call `next` on it. Note that, unlike ES6 iterators, these
start out pointing at the first element, so you should call `next`
only after reading the first range (if any).
*/
interface RangeCursor<T> {
    /**
    Move the iterator forward.
    */
    var next: () -> Void;
    /**
    The next range's value. Holds `null` when the cursor has reached
    its end.
    */
    var value: Null<T>;
    /**
    The next range's start position.
    */
    var from: Int;
    /**
    The next end position.
    */
    var to: Int;
}

typedef RangeSetUpdate<T: RangeValue> = {
    /**
    An array of ranges to add. If given, this should be sorted by
    `from` position and `startSide` unless
    [`sort`](https://codemirror.net/6/docs/ref/#state.RangeSet.update^updateSpec.sort) is given as
    `true`.
    */
    var ?add: Array<Range<T>>;
    /**
    Indicates whether the library should sort the ranges in `add`.
    Defaults to `false`.
    */
    var ?sort: Bool;
    /**
    Filter the ranges already in the set. Only those for which this
    function returns `true` are kept.
    */
    var ?filter: (from: Int, to: Int, value: T) -> Bool;
    /**
    Can be used to limit the range on which the filter is
    applied. Filtering only a small range, as opposed to the entire
    set, can make updates cheaper.
    */
    var ?filterFrom: Int;
    /**
    The end position to apply the filter to.
    */
    var ?filterTo: Int;
}

/**
A range set stores a collection of [ranges](https://codemirror.net/6/docs/ref/#state.Range) in a
way that makes them efficient to [map](https://codemirror.net/6/docs/ref/#state.RangeSet.map) and
[update](https://codemirror.net/6/docs/ref/#state.RangeSet.update). This is an immutable data
structure.
*/
extern class RangeSet<T: RangeValue> {
    private function new();
    
    /**
    The number of ranges in the set.
    */
    get size(): number;
    /**
    Update the range set, optionally adding new ranges or filtering
    out existing ones.
    
    (Note: The type parameter is just there as a kludge to work
    around TypeScript variance issues that prevented `RangeSet<X>`
    from being a subtype of `RangeSet<Y>` when `X` is a subtype of
    `Y`.)
    */
    update<U extends T>(updateSpec: RangeSetUpdate<U>): RangeSet<T>;
    /**
    Map this range set through a set of changes, return the new set.
    */
    map(changes: ChangeDesc): RangeSet<T>;
    /**
    Iterate over the ranges that touch the region `from` to `to`,
    calling `f` for each. There is no guarantee that the ranges will
    be reported in any specific order. When the callback returns
    `false`, iteration stops.
    */
    between(from: number, to: number, f: (from: number, to: number, value: T) => void | false): void;
    /**
    Iterate over the ranges in this set, in order, including all
    ranges that end at or after `from`.
    */
    iter(from?: number): RangeCursor<T>;
    /**
    Iterate over the ranges in a collection of sets, in order,
    starting from `from`.
    */
    static iter<T extends RangeValue>(sets: readonly RangeSet<T>[], from?: number): RangeCursor<T>;
    /**
    Iterate over two groups of sets, calling methods on `comparator`
    to notify it of possible differences.
    */
    static compare<T extends RangeValue>(oldSets: readonly RangeSet<T>[], newSets: readonly RangeSet<T>[], 
    /**
    This indicates how the underlying data changed between these
    ranges, and is needed to synchronize the iteration.
    */
    textDiff: ChangeDesc, comparator: RangeComparator<T>, 
    /**
    Can be used to ignore all non-point ranges, and points below
    the given size. When -1, all ranges are compared.
    */
    minPointSize?: number): void;
    /**
    Compare the contents of two groups of range sets, returning true
    if they are equivalent in the given range.
    */
    static eq<T extends RangeValue>(oldSets: readonly RangeSet<T>[], newSets: readonly RangeSet<T>[], from?: number, to?: number): boolean;
    /**
    Iterate over a group of range sets at the same time, notifying
    the iterator about the ranges covering every given piece of
    content. Returns the open count (see
    [`SpanIterator.span`](https://codemirror.net/6/docs/ref/#state.SpanIterator.span)) at the end
    of the iteration.
    */
    static spans<T extends RangeValue>(sets: readonly RangeSet<T>[], from: number, to: number, iterator: SpanIterator<T>, 
    /**
    When given and greater than -1, only points of at least this
    size are taken into account.
    */
    minPointSize?: number): number;
    /**
    Create a range set for the given range or array of ranges. By
    default, this expects the ranges to be _sorted_ (by start
    position and, if two start at the same position,
    `value.startSide`). You can pass `true` as second argument to
    cause the method to sort them.
    */
    static of<T extends RangeValue>(ranges: readonly Range<T>[] | Range<T>, sort?: boolean): RangeSet<T>;
    /**
    The empty set of ranges.
    */
    static empty: RangeSet<any>;
}

/**
A range set builder is a data structure that helps build up a
[range set](https://codemirror.net/6/docs/ref/#state.RangeSet) directly, without first allocating
an array of [`Range`](https://codemirror.net/6/docs/ref/#state.Range) objects.
*/
declare class RangeSetBuilder<T extends RangeValue> {
    private chunks;
    private chunkPos;
    private chunkStart;
    private last;
    private lastFrom;
    private lastTo;
    private from;
    private to;
    private value;
    private maxPoint;
    private setMaxPoint;
    private nextLayer;
    private finishChunk;
    /**
    Create an empty builder.
    */
    constructor();
    /**
    Add a range. Ranges should be added in sorted (by `from` and
    `value.startSide`) order.
    */
    add(from: number, to: number, value: T): void;
    /**
    Finish the range set. Returns the new set. The builder can't be
    used anymore after this has been called.
    */
    finish(): RangeSet<T>;
}
