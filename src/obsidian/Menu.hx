package obsidian;

import js.html.DocumentFragment;
import js.html.MouseEvent;
import js.html.KeyboardEvent;
import js.html.Document;
import haxe.extern.EitherType;

extern class MenuItem {
    function setTitle(title: EitherType<String, DocumentFragment>): MenuItem;

    /**
     * @param icon - ID of the icon, can use any icon loaded with {@link addIcon} or from the built-in lucide library.
     * @see The Obsidian icon library includes the {@link https://lucide.dev/ Lucide icon library}, any icon name from their site will work here.
     */
    function setIcon(icon: Null<String>): MenuItem;

    function setChecked(checked: Null<Bool>): MenuItem;
    function setDisabled(disabled: Bool): MenuItem;
    function setIsLabel(isLabel: Bool): MenuItem;
    function onClick(callback: (evt: EitherType<MouseEvent, KeyboardEvent>) -> Void): MenuItem;

    /**
     * Sets the section this menu item should belong in.
     * To find the section IDs of an existing menu, inspect the DOM elements
     * to see their `data-section` attribute.
     */
    function setSection(section: String): MenuItem;
}

typedef MenuPositionDef = {
    var x: Float;
    var y: Float;
    var ?width: Float;
    var ?overlap: Bool;
    var ?left: Bool;
}

extern class MenuSeparator {}

@:jsRequire("obsidian", "Menu")
extern class Menu extends Component {
    function new();
    function setNoIcon(): Menu;

    /**
     * Force this menu to use native or DOM.
     * (Only works on the desktop app)
     */
    function setUseNativeMenu(useNativeMenu: Bool): Menu;

    /**
     * Adds a menu item. Only works when menu is not shown yet.
     */
    function addItem(cb: (item: MenuItem) -> Void): Menu;

    /**
     * Adds a separator. Only works when menu is not shown yet.
     */
    function addSeparator(): Menu;

    function showAtMouseEvent(evt: MouseEvent): Menu;
    function showAtPosition(position: MenuPositionDef, ?doc: Document): Menu;
    function hide(): Menu;
    function close(): Void;
    function onHide(callback: () -> Void): Void;
}
