package obsidian;

import js.html.HtmlElement;

@:jsRequire("obsidian", "Plugin")
extern class MarkdownRenderChild extends Component {

    var containerEl (default, null): HtmlElement;

    /**
     * @param containerEl - This HTMLElement will be used to test whether this component is still alive.
     * It should be a child of the markdown preview sections, and when it's no longer attached
     * (for example, when it is replaced with a new version because the user edited the markdown source code),
     * this component will be unloaded.
     */
    function new(containerEl: HtmlElement);
}