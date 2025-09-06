package obsidian;

import js.html.Element;

interface MarkdownPostProcessorContext {

    public final docId: String;
    public final sourcePath: String;
    public final frontmatter: Null<Dynamic>;

    /**
     * Adds a child component that will have its lifecycle managed by the renderer.
     *
     * Use this to add a dependent child to the renderer such that if the containerEl
     * of the child is ever removed, the component's unload will be called.
     */
    public function addChild(child: MarkdownRenderChild): Void;

    /**
     * Gets the section information of this element at this point in time.
     * Only call this function right before you need this information to get the most up-to-date version.
     * This function may also return null in many circumstances;
     * if you use it, you must be prepared to deal with nulls.
     */
    public function getSectionInfo(el: Element): Null<MarkdownSectionInformation>;
}
