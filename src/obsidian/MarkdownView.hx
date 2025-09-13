package obsidian;

import obsidian.HoverParent.HoverPopover;

enum abstract MarkdownViewModeType(String) {
    var Source = "source";
    var Preview = "preview";
}

interface MarkdownSubView {
    function getScroll(): Float;
    function applyScroll(scroll: Float): Void;
    function get(): String;
    function set(data: String, clear: Bool): Void;
}

// Stub
extern class MarkdownPreviewView {}

@:jsRequire("obsidian", "MarkdownView")
extern class MarkdownView extends TextFileView implements MarkdownFileInfo {

    final editor: Editor;
    final previewMode: MarkdownPreviewView;
    final currentMode: MarkdownSubView;
    final hoverPopover: Null<HoverPopover>;

    function new(leaf: WorkspaceLeaf);

    function getViewType(): String;
    function getMode(): MarkdownViewModeType;
    function getViewData(): String;
    function clear(): Void;
    function setViewData(data: String, clear: Bool): Void;
    function showSearch(?replace: Bool): Void;
}