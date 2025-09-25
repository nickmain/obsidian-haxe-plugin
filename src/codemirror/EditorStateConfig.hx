package codemirror;

import haxe.extern.EitherType;

/**
Options passed when [creating](https://codemirror.net/6/docs/ref/#state.EditorState^create) an
editor state.
*/
typedef EditorStateConfig = {
    /**
    The initial document. Defaults to an empty document. Can be
    provided either as a plain string (which will be split into
    lines according to the value of the [`lineSeparator`
    facet](https://codemirror.net/6/docs/ref/#state.EditorState^lineSeparator)), or an instance of
    the [`Text`](https://codemirror.net/6/docs/ref/#state.Text) class (which is what the state will use
    to represent the document).
    */
    var ?doc: EitherType<String, Text>;

    /**
    The starting selection. Defaults to a cursor at the very start
    of the document.
    */
    var ?selection: EitherType<EditorSelection, { anchor: Int, ?head: Int }>;

    /**
    [Extension(s)](https://codemirror.net/6/docs/ref/#state.Extension) to associate with this state.
    */
    var ?extensions: Extension;
}