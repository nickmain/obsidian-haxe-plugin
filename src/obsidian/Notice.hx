package obsidian;

import js.html.DocumentFragment;
import js.html.HtmlElement;

@:jsRequire("obsidian", "Notice")
extern class Notice {
    public var noticeEl(default, null): HtmlElement;

    @:overload(function(message: DocumentFragment, ?duration: Float): Notice {})
    public function new(message: String, ?duration: Float);
    
    public function setMessage(message: String): Notice;
    public function hide(): Void;
}