package codemirror;

import haxe.extern.EitherType;

typedef Extension = EitherType<{extension: Extension}, Array<Extension>>;
