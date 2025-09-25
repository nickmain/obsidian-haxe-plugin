package epistem.js;

import haxe.iterators.ArrayIterator;
import js.lib.Object;

private class JSObjectEntryKVInterator<V> {
    final entryIterator: Iterator<ObjectEntry>;
    public function new(entryIterator: Iterator<ObjectEntry>) {
        this.entryIterator = entryIterator;
    }

    public function next(): {key: String, value: V} {
        final entry = entryIterator.next();
        final value: V = cast (entry.value);
        return {key: entry.key, value: value};
    }

    public function hasNext(): Bool {
        return entryIterator.hasNext();
    }
}

/**
 * String-Value iterator over a Javascript object.
 * Needed since Haxe Maps aren't implemented as raw JS objects.
 */
abstract JSObjectMap<V>(Object) {

    inline public function new(obj: Dynamic<V>) {
        this = cast(obj);
    }

    @:from
    static public function fromObject<V>(obj: Dynamic<V>) {
        return new JSObjectMap<V>(obj);
    }

    public function keyValueIterator(): KeyValueIterator<String, V> {
        final entryIterator = new ArrayIterator(Object.entries(this));
        return new JSObjectEntryKVInterator<V>(entryIterator);
    }
}
