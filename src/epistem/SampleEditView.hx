package epistem;

import js.html.MouseEvent;
import js.html.Element;
import obsidian.Notice;
import obsidian.WorkspaceLeaf;
import js.lib.Promise;
import obsidian.MarkdownView;

class SampleEditView extends MarkdownView {
    public static final VIEW_TYPE = "sample-edit-view";

    public function new(leaf: WorkspaceLeaf) {
        trace('new');
        super(leaf);
        allowNoFile = true;
    }

    override function getViewType(): String {
        return VIEW_TYPE;
    }

    override function getDisplayText(): String {
        return "Sample Edit View";
    }

    override function onOpen(): Promise<Void> {
        trace('onOpen');

        super.addAction("sunset", "Holler", (_) -> {
            final notice = new Notice("Holler !!");
            notice.noticeEl.style.backgroundColor = "yellow";
        });

        return super.onOpen().then((_) -> {
            setViewData("This is a virtual note", false);
        });
    }

    override function onClose(): Promise<Void> {
        trace('onClose');
        return super.onClose();
    }

    override function getViewData():String {
        trace('getViewData');
        return "This is a virtual note";
    }

    override function setViewData(data: String, clear: Bool) {
        trace('setViewData($data,$clear)');
        super.setViewData(data, clear);
    }

    override function save(?clear:Bool):Promise<Void> {
        trace('save($clear)');
        return super.save(clear);
    }

    override function clear() {
        trace("Clear");
        super.clear();
    }

    override function getMode():MarkdownViewModeType {
        trace('getMode() --> ${super.getMode()}');
        return super.getMode();
    }

    override function addAction(icon:String, title:String, callback:(evt:MouseEvent) -> Void): Element {
        trace('addAction($icon, $title)');
        return super.addAction(icon, title, disabledAction);
    }

    function disabledAction(evt: MouseEvent) {
        trace("DISABLED ACTION");
    }

    // function onUnloadFile(file: TFile): Promise<Void>;
    // function onLoadFile(file: TFile): Promise<Void>;
    // function showSearch(?replace: Bool): Void;
}