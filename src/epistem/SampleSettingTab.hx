package epistem;

import js.lib.Promise;
import obsidian.*;

class SampleSettingTab extends PluginSettingTab {
	final plugin: TestPlugin;

	public function new(app: App, plugin: TestPlugin) {
		super(app, plugin);
		this.plugin = plugin;
	}

	function display() {
        final containerEl = this.containerEl;

		containerEl.innerHTML = "";

		new Setting(containerEl)
			.setName('Setting #1')
			.setDesc('Text setting')
			.addText((text) -> text
				.setPlaceholder('Enter your secret')
				.setValue(plugin.settings.mySetting)
				.onChange((value) -> {
					plugin.settings.mySetting = value;
					return plugin.saveSettings().finally(() -> {
                        trace('Settings saved');
                    });
				}))
            .addButton((button) -> button
                .setIcon('command')
                .onClick((evt) -> {
                    trace('button clicked');
                    return null;
                }));

        new Setting(containerEl)
            .setName('Setting #2')
            .setDesc('Button settings')
            .addButton((button) -> button
                .setButtonText('Click Me')
                .onClick((evt) -> {
                    trace('button clicked');
                    return null;
                }))
            .addButton((button) -> button
                .setButtonText('Warning')
                .setWarning()
                .onClick((evt) -> {
                    trace('warning button clicked');
                    return null;
                }))
            .addButton((button) -> button
                .setButtonText('Call to action')
                .setCta()
                .onClick((evt) -> {
                    trace('CTA button clicked');
                    return null;
                }));

        new Setting(containerEl)
            .setName('Setting #3')
            .setDesc('Extra button settings with tooltip')
            .addExtraButton((button) -> button
                .setIcon('plus-with-circle')
                .setTooltip('Add something')
                .onClick(() -> {
                    trace('extra button clicked');
                    return null;
                }) );

        new Setting(containerEl)
            .setName('Setting #4')
            .setDesc('Toggle setting')
            .addToggle((toggle) -> toggle
                .setTooltip('This is a toggle setting')
                .setValue(true)
                .onChange((value) -> {
                    trace('toggle changed: $value');
                    return null;
                }));

        new Setting(containerEl)
            .setName('Setting #5')
            .setDesc('Drop-down setting')
            .addDropdown((dropdown) -> dropdown
                .addOption('option1', 'Apples')
                .addOption('option2', 'Bananas')
                .addOption('option3', 'Oranges')
                .setValue('option2')
                .onChange((value) -> {
                    trace('dropdown changed: $value');
                    return null;
                }));

        new Setting(containerEl)
            .setName('Setting #6')
            .setDesc('Color picker')
            .addColorPicker((color) -> color
                .setValue('#ffff22')
                .onChange((value) -> {
                    trace('color changed: ${color.getValueRgb()}');
                    return null;
                }) );

        new Setting(containerEl)
            .setName('Setting #7')
            .setDesc('Slider setting')
            .addSlider((slider) -> slider
                .setLimits(0, 100, Setting.SliderStep.Any)
                .setValue(42)
                .setDynamicTooltip()
                .onChange((value) -> {
                    trace('slider changed: $value');
                    return null;
                }) );

        new Setting(containerEl)
			.setName('Setting #8')
			.setDesc('Text are setting')
			.addTextArea((text) -> text
				.setPlaceholder('Enter some longer text')
				// .setValue("this.plugin.settings.mySetting")
				.onChange((value) -> {
                    trace('text area changed: $value');
                    return null;
				}));

        new Setting(containerEl)
			.setName('Setting #9')
			.setDesc('Search setting')
            .addSearch((search) -> search
                .setPlaceholder('Search here')
                // .setValue("this.plugin.settings.mySetting")
				.onChange((value) -> {
                    trace('search term changed: $value');
                    return null;
				}));

        final setting10 = new Setting(containerEl)
            .setName('Setting #10')
            .setDesc('Progress bar setting');

        setting10.addExtraButton((button) -> button
            .setIcon('minus-with-circle')
            .onClick(() -> {
                final progress = cast(setting10.components[1], Setting.ProgressBarComponent);
                final value = progress.getValue();
                progress.setValue(Math.max(0, value - 10));
                return null;
            })
        );
        setting10.addProgressBar((bar) -> bar.setValue(50));
        setting10.addExtraButton((button) -> button
            .setIcon('plus-with-circle')
            .onClick(() -> {
                final progress = cast(setting10.components[1], Setting.ProgressBarComponent);
                final value = progress.getValue();
                progress.setValue(Math.min(100, value + 10));
                return null;
            })
        );
	}
}