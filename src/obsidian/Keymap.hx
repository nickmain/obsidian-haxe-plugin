package obsidian;

extern class Keymap {

    function pushScope(scope: Scope): Void;
    function popScope(scope: Scope): Void;

    // /**
    //  * Checks whether the modifier key is pressed during this event
    //  */
    // static function isModifier(evt: MouseEvent | TouchEvent | KeyboardEvent, modifier: Modifier): boolean;

    // /**
    //  * Translates an event into the type of pane that should open.
    //  * Returns 'tab' if the modifier key Cmd/Ctrl is pressed OR if this is a middle-click MouseEvent.
    //  * Returns 'split' if Cmd/Ctrl+Alt is pressed.
    //  * Returns 'window' if Cmd/Ctrl+Alt+Shift is pressed.
    //  * */
    // static function isModEvent(evt?: UserEvent | null): PaneType | boolean;
}