package obsidian;

import js.lib.Promise;
import haxe.extern.EitherType;

typedef EditorSuggestTriggerInfo = {
    /** The start position of the triggering text. This is used to position the popover. */
    var start: Editor.EditorPosition;

    /** The end position of the triggering text. This is used to position the popover. */
    var end: Editor.EditorPosition;

    /** They query string (usually the text between start and end) that will be used to generate the suggestion content. */
    var query: String;
}

typedef EditorSuggestContext = EditorSuggestTriggerInfo & {
    var editor: Editor;
    var file: TFile;
}

typedef Instruction = { command: String, purpose: String }

@:jsRequire("obsidian", "EditorSuggest")
extern abstract class EditorSuggest<T> extends PopoverSuggest<T> {
    /**
     * Current suggestion context, containing the result of `onTrigger`.
     * This will be null any time the EditorSuggest is not supposed to run.
     */
    var context: Null<EditorSuggestContext>;

    /**
     * Override this to use a different limit for suggestion items
     */
    var limit: Int;

    function new(app: App);

    function setInstructions(instructions: Array<Instruction>): Void;

    /**
     * Based on the editor line and cursor position, determine if this EditorSuggest should be triggered at this moment.
     * Typically, you would run a regular expression on the current line text before the cursor.
     * Return null to indicate that this editor suggest is not supposed to be triggered.
     *
     * Please be mindful of performance when implementing this function, as it will be triggered very often (on each keypress).
     * Keep it simple, and return null as early as possible if you determine that it is not the right time.
     */
    abstract function onTrigger(cursor: Editor.EditorPosition, editor: Editor, file: Null<TFile>): Null<EditorSuggestTriggerInfo>;

    /**
     * Generate suggestion items based on this context. Can be async, but preferably sync.
     * When generating async suggestions, you should pass the context along.
     */
    abstract function getSuggestions(context: EditorSuggestContext): EitherType<Array<T>, Promise<Array<T>>>;
}