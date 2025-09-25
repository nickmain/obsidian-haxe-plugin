package codemirror;

import js.html.Animation;
import js.html.StyleSheetList;
import js.html.CSSStyleSheet;
import js.html.DOMElement;

interface DocumentOrShadowRoot {
    /**
     * Returns the deepest element in the document through which or to which key events are being routed. This is, roughly speaking, the focused element in the document.
     *
     * For the purposes of this API, when a child browsing context is focused, its container is focused in the parent browsing context. For example, if the user moves the focus to a text control in an iframe, the iframe is the element returned by the activeElement API in the iframe's node document.
     *
     * Similarly, when the focused element is in a different node tree than documentOrShadowRoot, the element returned will be the host that's located in the same node tree as documentOrShadowRoot if documentOrShadowRoot is a shadow-including inclusive ancestor of the focused element, and null if not.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/activeElement)
     */
    final activeElement: Null<DOMElement>;

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/adoptedStyleSheets) */
    var adoptedStyleSheets: Array<CSSStyleSheet>;

    /**
     * Returns document's fullscreen element.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/fullscreenElement)
     */
    final fullscreenElement: Null<DOMElement>;

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/pictureInPictureElement) */
    final pictureInPictureElement: Null<DOMElement>;

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/pointerLockElement) */
    final pointerLockElement: Null<DOMElement>;

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/styleSheets) */
    final styleSheets: StyleSheetList;

    function elementFromPoint(x: Int, y: Int): Null<DOMElement>;
    function elementsFromPoint(x: Int, y: Int): Array<DOMElement>;

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/getAnimations) */
    function getAnimations(): Array<Animation>;
}