package obsidian;

import js.html.Element;

extern enum PopoverState {}

@:jsRequire("obsidian", "HoverPopover")
extern class HoverPopover extends Component {
    var hoverEl: Element;
    var state: PopoverState;
    function  new(parent: HoverParent, targetEl: Null<Element>, ?waitTime: Float);
}

interface HoverParent {
    final hoverPopover: Null<HoverPopover>;
}
