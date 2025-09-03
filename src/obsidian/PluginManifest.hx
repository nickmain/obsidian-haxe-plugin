package obsidian;

interface PluginManifest {
    /**
     * Vault path to the plugin folder in the config directory.
     */
    final dir: Null<String>;

    /**
     * The plugin ID.
     */
    final id: String;

    /**
     * The display name.
     */
    final name: String;

    /**
     * The author's name.
     */
    final author: String;

    /**
     * The current version, using {@link https://semver.org/ Semantic Versioning}.
     */
    final version: String;

    /**
     * The minimum required Obsidian version to run this plugin.
     */
    final minAppVersion: String;

    /**
     * A description of the plugin.
     */
    final description: String;

    /**
     * A URL to the author's website.
     */
    final authorUrl: Null<String>;

    /**
     * Whether the plugin can be used only on desktop.
     */
    final isDesktopOnly: Null<Bool>;
}