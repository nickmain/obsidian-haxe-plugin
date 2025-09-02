package obsidian;

import js.lib.Promise;
import js.html.HtmlElement;
import js.html.MouseEvent;

@:jsRequire("obsidian", "Plugin")
extern abstract class Plugin {
    abstract function onload(): Promise<Void>;
    abstract function onunload(): Void;

    final function loadData(): Promise<Dynamic>;
    final function saveData(data: Dynamic): Promise<Void>;

    /**
     * Register a special post processor that handles fenced code given a language and a handler.
     * This special post processor takes care of removing the <pre><code> and create a <div> that
     * will be passed to the handler, and is expected to be filled with custom elements.
     */
    function registerMarkdownCodeBlockProcessor(
        language: String, 
        handler: (source: String, el: HtmlElement, ctx: MarkdownPostProcessorContext) -> Promise<Void>, 
        ?sortOrder: Float): MarkdownPostProcessor;

    function addRibbonIcon(icon: String, title: String, callback: (evt: MouseEvent) -> Void): HtmlElement;
}
