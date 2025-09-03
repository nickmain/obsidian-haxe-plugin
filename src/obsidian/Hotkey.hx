package obsidian;

/**
 * Mod = Cmd on MacOS and Ctrl on other OS
 * Ctrl = Ctrl key for every OS
 * Meta = Cmd on MacOS and Win key on other OS
 */
enum abstract Modifier(String) {
   var Mod;
   var Ctrl;
   var Meta;
   var Shift; 
   var Alt;
}

interface Hotkey {
    final modifiers: Array<Modifier>;
    final key: String;
}