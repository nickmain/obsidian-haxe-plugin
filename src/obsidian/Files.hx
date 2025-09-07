package obsidian;


enum abstract StatType(String) {
    var File = "file";
    var Folder = "folder";
}

interface Stat extends FileStats {
    final type: StatType;
}

interface FileStats {
    /** Time of creation, represented as a unix timestamp, in milliseconds. */
    final ctime: Float;

    /** Time of last modification, represented as a unix timestamp, in milliseconds. */
    final mtime: Float;

    /** Size on disk, as bytes. */
    final size: Int;
}

@:jsRequire("obsidian", "TFolder")
extern class TFolder extends TAbstractFile {
    final children: Array<TAbstractFile>;
    function isRoot(): Bool;
}

extern abstract class TAbstractFile {
    final vault: Vault;
    final path: String;
    final name: String;
    final parent: Null<TFolder>;
}

@:jsRequire("obsidian", "TFile")
extern class TFile extends TAbstractFile {
    final stat: FileStats;
    final basename: String;
    final extension: String;
}
