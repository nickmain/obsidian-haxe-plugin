package obsidian;

import js.html.Element;
import js.lib.Promise;

typedef MarkdownPostProcessor = (el: Element, ctx: MarkdownPostProcessorContext) -> Promise<Void>;

// class MarkdownPostProcessor {
//     /**
//      * The processor function itself.
//      */
//     (el: HTMLElement, ctx: MarkdownPostProcessorContext): Promise<any> | void;

//     /**
//      * An optional integer sort order. Defaults to 0. Lower number runs before higher numbers.
//      */
//     var sortOrder: Null<Int>;
// }