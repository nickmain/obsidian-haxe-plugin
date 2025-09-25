package codemirror;

typedef StateEffectSpec<Value> = {
    /**
    Provides a way to map an effect like this through a position
    mapping. When not given, the effects will simply not be mapped.
    When the function returns `undefined`, that means the mapping
    deletes the effect.
    */
    var ?map: (value: Value, mapping: ChangeDesc) -> Null<Value>;
}

/**
Representation of a type of state effect. Defined with
[`StateEffect.define`](https://codemirror.net/6/docs/ref/#state.StateEffect^define).
*/
extern class StateEffectType<Value> {
    final map: (value: Any, mapping: ChangeDesc) -> Null<Any>;

    /** Create a [state effect](https://codemirror.net/6/docs/ref/#state.StateEffect) instance of this type. */
    function of(value: Value): StateEffect<Value>;
}

/**
State effects can be used to represent additional effects
associated with a [transaction](https://codemirror.net/6/docs/ref/#state.Transaction.effects). They
are often useful to model changes to custom [state
fields](https://codemirror.net/6/docs/ref/#state.StateField), when those changes aren't implicit in
document or selection changes.
*/
extern class StateEffect<Value> {
    /**
    The value of this effect.
    */
    final value: Value;

    /**
    Map this effect through a position mapping. Will return
    `undefined` when that ends up deleting the effect.
    */
    function map(mapping: ChangeDesc): Null<StateEffect<Value>>;

    /**
    Tells you whether this effect object is of a given
    [type](https://codemirror.net/6/docs/ref/#state.StateEffectType).
    */
    function is<T>(type: StateEffectType<T>): Bool;

    /**
    Define a new effect type. The type parameter indicates the type
    of values that his effect holds. It should be a type that
    doesn't include `undefined`, since that is used in
    [mapping](https://codemirror.net/6/docs/ref/#state.StateEffect.map) to indicate that an effect is
    removed.
    */
    static function define<Value>(?spec: StateEffectSpec<Value>): StateEffectType<Value>;

    /**
    Map an array of effects through a change set.
    */
    static function mapEffects(effects: Array<StateEffect<Any>>, mapping: ChangeDesc): Array<StateEffect<Any>>;

    /**
    This effect can be used to reconfigure the root extensions of
    the editor. Doing this will discard any extensions
    [appended](https://codemirror.net/6/docs/ref/#state.StateEffect^appendConfig), but does not reset
    the content of [reconfigured](https://codemirror.net/6/docs/ref/#state.Compartment.reconfigure)
    compartments.
    */
    static var reconfigure: StateEffectType<Extension>;

    /**
    Append extensions to the top-level configuration of the editor.
    */
    static var appendConfig: StateEffectType<Extension>;
}
