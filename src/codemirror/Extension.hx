package codemirror;

import haxe.extern.EitherType;

typedef Extension = EitherType<{extension: Extension}, Array<Extension>>;

/**
By default extensions are registered in the order they are found
in the flattened form of nested array that was provided.
Individual extension values can be assigned a precedence to
override this. Extensions that do not have a precedence set get
the precedence of the nearest parent with a precedence, or
[`default`](https://codemirror.net/6/docs/ref/#state.Prec.default) if there is no such parent. The
final ordering of extensions is determined by first sorting by
precedence and then by order within each precedence.
*/
@:jsRequire("@codemirror/state", "Prec")
extern class Prec {
    /**
    The highest precedence level, for extensions that should end up
    near the start of the precedence ordering.
    */
    static final highest: (ext: Extension) -> Extension;
    /**
    A higher-than-default precedence, for extensions that should
    come before those with default precedence.
    */
    static final high: (ext: Extension) -> Extension;
    /**
    The default precedence, which is also used for extensions
    without an explicit precedence.
    */
    @:native("default")
    static final default_: (ext: Extension) -> Extension;
    /**
    A lower-than-default precedence.
    */
    static final low: (ext: Extension) -> Extension;
    /**
    The lowest precedence level. Meant for things that should end up
    near the end of the extension order.
    */
    static final lowest: (ext: Extension) -> Extension;
}
