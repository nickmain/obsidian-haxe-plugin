package obsidian;

import js.html.HtmlElement;
import js.html.MouseEvent;
import js.html.KeyboardEvent;
import haxe.extern.EitherType;

@:jsRequire("obsidian", "PopoverSuggest")
extern abstract class PopoverSuggest<T> {
    final app: App;
    final scope: Scope;

    function new(app: App, ?scope: Scope);

    function open(): Void;
    function close(): Void;
    abstract function renderSuggestion(value: T, el: HtmlElement): Void;
    abstract function selectSuggestion(value: T, evt: EitherType<MouseEvent, KeyboardEvent>): Void;
}
