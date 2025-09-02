package obsidian;

extern class Component {

    /**
     * Load this component and its children
     */
    function load(): Void;

    /**
     * Override this to load your component
     */
    function onload(): Void;

    /**
     * Unload this component and its children
     */
    function unload(): Void;

    /**
     * Override this to unload your component
     */
    function onunload(): Void;

    /**
     * Adds a child component, loading it if this component is loaded
     */
    function addChild(component: Component): Component;

    /**
     * Removes a child component, unloading it
     */
    function removeChild(component: Component): Component;

    /**
     * Registers a callback to be called when unloading
     */
    function register(cb: () -> Void): Void;

    /**
     * Registers an event to be detached when unloading
     */
    // function registerEvent(eventRef: EventRef): Void;

    /**
     * Registers an DOM event to be detached when unloading
     */
    // function registerDomEvent<K extends keyof WindowEventMap>(el: Window, type: K, callback: (this: HtmlElement, ev: WindowEventMap[K]) => any, options?: boolean | AddEventListenerOptions): Void;

    /**
     * Registers an DOM event to be detached when unloading
     */
    // function registerDomEvent<K extends keyof DocumentEventMap>(el: Document, type: K, callback: (this: HtmlElement, ev: DocumentEventMap[K]) => any, options?: boolean | AddEventListenerOptions): Void;

    /**
     * Registers an DOM event to be detached when unloading
     */
    // function registerDomEvent<K extends keyof HTMLElementEventMap>(el: HTMLElement, type: K, callback: (this: HtmlElement, ev: HTMLElementEventMap[K]) => any, options?: boolean | AddEventListenerOptions): Void;

    /**
     * Registers an interval (from setInterval) to be cancelled when unloading
     * Use {@link window.setInterval} instead of {@link setInterval} to avoid TypeScript confusing between NodeJS vs Browser API
     */
    function registerInterval(id: Float): Float;
}
