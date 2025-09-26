package codemirror;

import haxe.extern.EitherType;


enum abstract SlotString(String) {
    var Doc = "doc";
    var Selection = "selection";
}

typedef Slot<T> =  EitherType<EitherType<Facet<Any, T>, StateField<T>>, SlotString>;

typedef FacetConfig<Input, Output> = {
    /**
    How to combine the input values into a single output value. When
    not given, the array of input values becomes the output. This
    function will immediately be called on creating the facet, with
    an empty array, to compute the facet's default value when no
    inputs are present.
    */
    var ?combine: (value: Array<Input>) -> Output;

    /**
    How to compare output values to determine whether the value of
    the facet changed. Defaults to comparing by `===` or, if no
    `combine` function was given, comparing each element of the
    array with `===`.
    */
    var ?compare: (a: Output, b: Output) -> Bool;

    /**
    How to compare input values to avoid recomputing the output
    value when no inputs changed. Defaults to comparing with `===`.
    */
    var ?compareInput: (a: Input, b: Input) -> Bool;

    /**
    Forbids dynamic inputs to this facet.
    */
    @:native("static") var ?static_: Bool;

    /**
    If given, these extension(s) (or the result of calling the given
    function with the facet) will be added to any state where this
    facet is provided. (Note that, while a facet's default value can
    be read from a state even if the facet wasn't present in the
    state at all, these extensions won't be added in that
    situation.)
    */
    var ?enables: EitherType<Extension, ((self: Facet<Input, Output>) -> Extension)>;
};

/**
A facet is a labeled value that is associated with an editor
state. It takes inputs from any number of extensions, and combines
those into a single output value.

Examples of uses of facets are the [tab
size](https://codemirror.net/6/docs/ref/#state.EditorState^tabSize), [editor
attributes](https://codemirror.net/6/docs/ref/#view.EditorView^editorAttributes), and [update
listeners](https://codemirror.net/6/docs/ref/#view.EditorView^updateListener).
*/
extern class Facet<Input, Output> {

    private function new();

    /**
    Define a new facet.
    */
    static function define<Input>(?config: FacetConfig<Input, Array<Input>>): Facet<Input, Array<Input>>;

    /**
    Returns an extension that adds the given value to this facet.
    */
    function of(value: Input): Extension;

    /**
    Create an extension that computes a value for the facet from a
    state. You must take care to declare the parts of the state that
    this value depends on, since your function is only called again
    for a new state when one of those parts changed.
    
    In cases where your value depends only on a single field, you'll
    want to use the [`from`](https://codemirror.net/6/docs/ref/#state.Facet.from) method instead.
    */
    function compute(deps: Array<Slot<Any>>, get: (state: EditorState) -> Input): Extension;

    /**
    Create an extension that computes zero or more values for this
    facet from a state.
    */
    function computeN(deps: Array<Slot<Any>>, get: (state: EditorState) -> Array<Input>): Extension;

    /**
    Shorthand method for registering a facet source with a state
    field as input. If the field's type corresponds to this facet's
    input type, the getter function can be omitted. If given, it
    will be used to retrieve the input from the field value.
    */
    @:overload(function<T: Input>(field: StateField<T>): Extension {})
    function from<T>(field: StateField<T>, get: (value: T) -> Input): Extension;
}
