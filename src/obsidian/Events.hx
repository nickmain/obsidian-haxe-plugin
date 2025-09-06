package obsidian;

import js.html.PointerEvent;
import js.html.TouchEvent;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import js.html.AbortSignal;
import haxe.extern.EitherType;

typedef UserEvent = EitherType<EitherType<MouseEvent, KeyboardEvent>, EitherType<TouchEvent, PointerEvent>>

interface EventRef {
    // empty
}

typedef EventListenerOptions = { ?capture: Bool }
typedef AddEventListenerOptions = EventListenerOptions & { ?once: Bool, ?passive: Bool, ?signal: AbortSignal }

extern class Events {
    function on(name: String, callback: (data: Array<Any>) -> Void, ?ctx: Any): EventRef;
    function off(name: String, callback: (data: Array<Any>) -> Void): Void;
    function offref(ref: EventRef): Void;
    function trigger(name: String, data: Array<Any>): Void;
    function tryTrigger(evt: EventRef, args: Array<Any>): Void;
}
