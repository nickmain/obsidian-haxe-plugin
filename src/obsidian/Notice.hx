package obsidian;

import js.html.DocumentFragment;
import js.html.Element;

@:jsRequire("obsidian", "Notice")
extern class Notice {
    public final noticeEl: Element;

    @:overload(function(message: DocumentFragment, ?duration: Float): Notice {})
    public function new(message: String, ?duration: Float);

    public function setMessage(message: String): Notice;
    public function hide(): Void;
}
