package obsidian;

import obsidian.Events.UserEvent;

interface App {
    final keymap: Keymap;
    final scope: Scope;
    final workspace: Workspace;
    final vault: Vault;
    final metadataCache: MetadataCache;
    final fileManager: FileManager;
    final lastEvent: Null<UserEvent>;
}
