package obsidian;

import js.html.HtmlElement;

@:jsRequire("obsidian", "Modal")
extern abstract class Modal {
    final app: App;
    final scope: Scope;
    final containerEl: HtmlElement;
    final modalEl: HtmlElement;
    final titleEl: HtmlElement;
    final contentEl: HtmlElement;
    var shouldRestoreSelection: Bool;

    function new(app: App);

    function open(): Void;
    function close(): Void;

    abstract function onOpen(): Void;
    abstract function onClose(): Void;
}
