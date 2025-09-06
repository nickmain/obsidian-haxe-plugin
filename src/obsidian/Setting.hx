package obsidian;

import js.html.TextAreaElement;
import js.html.MouseEvent;
import js.html.ButtonElement;
import js.lib.Promise;
import js.html.InputElement;
import js.html.DocumentFragment;
import js.html.Element;
import haxe.extern.EitherType;


@:jsRequire("obsidian", "BaseComponent")
extern class BaseComponent {
    final disabled: Bool;
    function then(cb: (component: BaseComponent) -> Void): BaseComponent;
    function setDisabled(disabled: Bool): BaseComponent;
}

@:jsRequire("obsidian", "ValueComponent")
extern abstract class ValueComponent<T> extends BaseComponent {
    // function registerOptionListener(listeners: Record<String, (?value: T) -> T>, key: String): ValueComponent<T>;
    abstract function getValue(): T;
    abstract function setValue(value: T): ValueComponent<T>;
}

@:jsRequire("obsidian", "AbstractTextComponent")
extern class AbstractTextComponent<T> extends ValueComponent<String> {
    final inputEl: T;
    // constructor(inputEl: T);
    function setDisabled(disabled: Bool): AbstractTextComponent<T>;
    function getValue(): String;
    function setValue(value: String): AbstractTextComponent<T>;
    function setPlaceholder(placeholder: String): AbstractTextComponent<T>;
    function onChanged(): Void;
    function onChange(callback: (value: String) -> Null<Promise<Void>>): AbstractTextComponent<T>;
}

@:jsRequire("obsidian", "TextComponent")
extern class TextComponent extends AbstractTextComponent<InputElement> {
    function new(containerEl: Element);
}

@:jsRequire("obsidian", "ButtonComponent")
extern class ButtonComponent extends BaseComponent {
    final buttonEl: ButtonElement;
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): ButtonComponent;
    function setCta(): ButtonComponent;
    function removeCta(): ButtonComponent;
    function setWarning(): ButtonComponent;
    function setTooltip(tooltip: String, ?options: TooltipOptions): ButtonComponent;
    function setButtonText(name: String): ButtonComponent;
    function setIcon(icon: String): ButtonComponent;
    function setClass(cls: String): ButtonComponent;
    function onClick(callback: (evt: MouseEvent) -> Null<Promise<Void>>): ButtonComponent;
}

@:jsRequire("obsidian", "ProgressBarComponent")
extern class ExtraButtonComponent extends BaseComponent {
    final extraSettingsEl: Element;
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): ExtraButtonComponent;
    function setTooltip(tooltip: String, ?options: TooltipOptions): ExtraButtonComponent;
    function setIcon(icon: String): ExtraButtonComponent;
    function onClick(callback: () -> Null<Promise<Void>>): ExtraButtonComponent;
}

@:jsRequire("obsidian", "ToggleComponent")
extern class ToggleComponent extends ValueComponent<Bool> {
    final toggleEl: Element;
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): ToggleComponent;
    function getValue(): Bool;
    function setValue(on: Bool): ToggleComponent;
    function setTooltip(tooltip: String, ?options: TooltipOptions): ToggleComponent;
    function onClick(): Void;
    function onChange(callback: (value: Bool) -> Null<Promise<Void>>): ToggleComponent;
}

@:jsRequire("obsidian", "ProgressBarComponent")
extern class DropdownComponent extends ValueComponent<String> {
    final selectEl: Element;
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): DropdownComponent;
    function addOption(value: String, display: String): DropdownComponent;
    // addOptions(options: Record<String, String>): DropdownComponent;
    function getValue(): String;
    function setValue(value: String): DropdownComponent;
    function onChange(callback: (value: String) -> Null<Promise<Void>>): DropdownComponent;
}

typedef HexString = String;
typedef RGB = { r: Int, g: Int, b: Int };
typedef HSL = { h: Int, s: Int, l: Int };

@:jsRequire("obsidian", "ColorComponent")
extern class ColorComponent extends ValueComponent<String> {
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): ColorComponent;
    function getValue(): HexString;
    function getValueRgb(): RGB;
    function getValueHsl(): HSL;
    function setValue(value: HexString): ColorComponent;
    function setValueRgb(rgb: RGB): ColorComponent;
    function setValueHsl(hsl: HSL): ColorComponent;
    function onChange(callback: (value: String) -> Null<Promise<Void>>): ColorComponent;
}

enum abstract SliderStep(String) { var Any = "any"; }

@:jsRequire("obsidian", "SliderComponent")
extern class SliderComponent extends ValueComponent<Float> {
    final sliderEl: Element;
    // constructor(containerEl: Element);
    function setDisabled(disabled: Bool): SliderComponent;
    function setLimits(min: Float, max: Float, step: EitherType<Float, SliderStep>): SliderComponent;
    function getValue(): Float;
    function setValue(value: Float): SliderComponent;
    function getValuePretty(): String;
    function setDynamicTooltip(): SliderComponent;
    function showTooltip(): Void;
    function onChange(callback: (value: Float) -> Null<Promise<Void>>): SliderComponent;
}

@:jsRequire("obsidian", "TextAreaComponent")
extern class TextAreaComponent extends AbstractTextComponent<TextAreaElement> {
    // constructor(containerEl: Element);
}

@:jsRequire("obsidian", "SearchComponent")
extern class SearchComponent extends AbstractTextComponent<InputElement> {
    final clearButtonEl: Element;
    // constructor(containerEl: Element);
   function onChanged(): Void;
}

@:jsRequire("obsidian", "ProgressBarComponent")
extern class ProgressBarComponent extends ValueComponent<Float> {
    // constructor(containerEl: Element);
    function getValue(): Float;
    function setValue(value: Float): ProgressBarComponent;
}

enum abstract TooltipPlacement(String) { var bottom; var right; var left; var top; }
typedef TooltipOptions = { ?placement: TooltipPlacement, ?delay: Float }

@:jsRequire("obsidian", "Setting")
extern class Setting {
    final settingEl: Element;
    final infoEl: Element;
    final nameEl: Element;
    final descEl: Element;
    final controlEl: Element;
    final components: Array<BaseComponent>;

    function new(containerEl: Element);

    function setName(name: EitherType<String, DocumentFragment>): Setting;
    function setDesc(desc: EitherType<String, DocumentFragment>): Setting;
    function setClass(cls: String): Setting;
    function setTooltip(tooltip: String, ?options: TooltipOptions): Setting;
    function setHeading(): Setting;
    function setDisabled(disabled: Bool): Setting;
    function addButton(cb: (component: ButtonComponent) -> Void): Setting;
    function addExtraButton(cb: (component: ExtraButtonComponent) -> Void): Setting;
    function addToggle(cb: (component: ToggleComponent) -> Void): Setting;
    function addText(cb: (component: TextComponent) -> Void): Setting;
    function addSearch(cb: (component: SearchComponent) -> Void): Setting;
    function addTextArea(cb: (component: TextAreaComponent) -> Void): Setting;
    // function addMomentFormat(cb: (component: MomentFormatComponent) -> Void): Setting;
    function addDropdown(cb: (component: DropdownComponent) -> Void): Setting;
    function addColorPicker(cb: (component: ColorComponent) -> Void): Setting;
    function addProgressBar(cb: (component: ProgressBarComponent) -> Void): Setting;
    function addSlider(cb: (component: SliderComponent) -> Void): Setting;
    function then(cb: (setting: Setting) -> Void): Setting;
    function clear(): Setting;
}
