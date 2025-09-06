package obsidian;

import js.html.Element;

@:jsRequire("obsidian", "Plugin")
extern class MarkdownRenderChild extends Component {

    final containerEl: Element;

    /**
     * @param containerEl - This Element will be used to test whether this component is still alive.
     * It should be a child of the markdown preview sections, and when it's no longer attached
     * (for example, when it is replaced with a new version because the user edited the markdown source code),
     * this component will be unloaded.
     */
    function new(containerEl: Element);
}
