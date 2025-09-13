package obsidian;

import obsidian.Files.TFile;

interface MarkdownFileInfo extends HoverParent {

    final app: App;

    var file (default, null): Null<TFile>;

    final editor: Null<Editor>;
}