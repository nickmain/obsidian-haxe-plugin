package obsidian;

import obsidian.Events.EventRef;
import obsidian.Events.AddEventListenerOptions;
import js.html.Event;
import js.html.Window;
import js.html.Document;
import js.html.HtmlElement;
import haxe.extern.EitherType;

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
    function registerEvent(eventRef: EventRef): Void;

    /**
     * Registers an DOM event to be detached when unloading
     */
    @:overload(function(el: Window, type: String, callback: (ev: Event) -> Void, ?options: EitherType<Bool, AddEventListenerOptions>): Void {})
    @:overload(function(el: Document, type: String, callback: (ev: Event) -> Void, ?options: EitherType<Bool, AddEventListenerOptions>): Void {})
    function registerDomEvent(el: HtmlElement, type: String, callback: (ev: Event) -> Void, ?options: EitherType<Bool, AddEventListenerOptions>): Void;

    /**
     * Registers an interval (from setInterval) to be cancelled when unloading
     * Use {@link window.setInterval} instead of {@link setInterval} to avoid TypeScript confusing between NodeJS vs Browser API
     */
    function registerInterval(id: Float): Float;
}
