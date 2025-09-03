package obsidian;

import haxe.extern.EitherType;

typedef Command = {
    /**
     * Globally unique ID to identify this command.
     */
    final id: String;

    /**
     * Human friendly name for searching.
     */
    final name: String;

    /**
     * Icon ID to be used in the toolbar.
     */
    final ?icon: String;

    final ?mobileOnly: Bool;

    /**
     * Whether holding the hotkey should repeatedly trigger this command. Defaults to false.
     */
    final ?repeatable: Bool;

    /**
     * Simple callback, triggered globally.
     */
    final ?callback: () -> Void;

    /**
     * Complex callback, overrides the simple callback.
     * Used to "check" whether your command can be performed in the current circumstances.
     * For example, if your command requires the active focused pane to be a MarkdownSourceView, then
     * you should only return true if the condition is satisfied. Returning false or undefined causes
     * the command to be hidden from the command palette.
     *
     * @param checking - Whether the command palette is just "checking" if your command should show right now.
     * If checking is true, then this function should not perform any action.
     * If checking is false, then this function should perform the action.
     * @returns Whether this command can be executed at the moment.
     */
    final ?checkCallback: (checking: Bool) -> EitherType<Bool, Void>;

    /**
     * A command callback that is only triggered when the user is in an editor.
     * Overrides `callback` and `checkCallback`
     */
    final ?editorCallback: (editor: Editor, ctx: EitherType<MarkdownView, MarkdownFileInfo>) -> Void;

    /**
     * A command callback that is only triggered when the user is in an editor.
     * Overrides `editorCallback`, `callback` and `checkCallback`
     */
    final ?editorCheckCallback: (checking: Bool, editor: Editor, ctx: EitherType<MarkdownView, MarkdownFileInfo>) -> EitherType<Bool, Void>;

    /**
     * Sets the default hotkey. It is recommended for plugins to avoid setting default hotkeys if possible,
     * to avoid conflicting hotkeys with one that's set by the user, even though customized hotkeys have higher priority.
     */
    final ?hotkeys: Array<Hotkey>;
}
