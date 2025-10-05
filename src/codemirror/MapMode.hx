package codemirror;

/**
Distinguishes different ways in which positions can be mapped.
*/
enum abstract MapMode(Int) {
    /** Map a position to a valid new position, even when its context was deleted. */
    var Simple = 0;

    /** Return null if deletion happens across the position. */
    var TrackDel = 1;

    /** Return null if the character _before_ the position is deleted. */
    var TrackBefore = 2;

    /** Return null if the character _after_ the position is deleted. */
    var TrackAfter = 3;
}