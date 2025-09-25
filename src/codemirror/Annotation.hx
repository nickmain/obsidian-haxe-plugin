package codemirror;

/**
Annotations are tagged values that are used to add metadata to
transactions in an extensible way. They should be used to model
things that effect the entire transaction (such as its [time
stamp](https://codemirror.net/6/docs/ref/#state.Transaction^time) or information about its
[origin](https://codemirror.net/6/docs/ref/#state.Transaction^userEvent)). For effects that happen
_alongside_ the other changes made by the transaction, [state
effects](https://codemirror.net/6/docs/ref/#state.StateEffect) are more appropriate.
*/
extern class Annotation<T> {
    /**
    The annotation type.
    */
    final type: AnnotationType<T>;
    /**
    The value of this annotation.
    */
    final value: T;
    /**
    Define a new type of annotation.
    */
    static function define<T>(): AnnotationType<T>;
}

/**
Marker that identifies a type of [annotation](https://codemirror.net/6/docs/ref/#state.Annotation).
*/
extern class AnnotationType<T> {
    /** Create an instance of this annotation. */
    function of(value: T): Annotation<T>;
}
