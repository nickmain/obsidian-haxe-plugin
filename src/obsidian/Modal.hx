package obsidian;

import js.html.Element;

@:jsRequire("obsidian", "Modal")
extern abstract class Modal {
    final app: App;
    final scope: Scope;
    final containerEl: Element;
    final modalEl: Element;
    final titleEl: Element;
    final contentEl: Element;
    var shouldRestoreSelection: Bool;

    function new(app: App);

    function open(): Void;
    function close(): Void;

    abstract function onOpen(): Void;
    abstract function onClose(): Void;
}
