package epistem;

import obsidian.EditorSuggest;
import js.html.HtmlElement;
import js.html.MouseEvent;
import js.html.KeyboardEvent;
import haxe.extern.EitherType;
import obsidian.EditorSuggest.EditorSuggestContext;
import obsidian.Editor;
import obsidian.Files.TFile;
import obsidian.EditorSuggest.EditorSuggestTriggerInfo;

class SampleSuggester extends EditorSuggest<String> {

	public function new(plugin: TestPlugin) {
		super(plugin.app);

		this.setInstructions([
			{ command: "Enter", purpose: "Insert suggestion" },
			{ command: "Esc", purpose: "Cancel" }
		]);
	}

	function getSuggestions(ctx: EditorSuggestContext) {
		return ["Apples", "Oranges", "Bananas", "Grapes"];
	}

	function renderSuggestion(text: String, el: HtmlElement) {
		final span = el.ownerDocument.createSpanElement();
		span.innerText = text;
		el.appendChild(span);
	}

	function selectSuggestion(value: String, evt: EitherType<MouseEvent, KeyboardEvent>) {
		if (this.context == null) return;

		this.context.editor.replaceRange(
			value,
			this.context.start,
			this.context.end,
			"froot"
		);

		this.close();
	}

    function onTrigger(cursor: EditorPosition, editor: Editor, file: TFile): Null<EditorSuggestTriggerInfo> {
		final line = editor.getLine(cursor.line);

		if (cursor.ch < 5) return null;
		if (line.substr(cursor.ch - 5, 5) != "froot") return null;

		final matchData = {
			end: cursor,
			start: { ch: cursor.ch - 5, line: cursor.line },
			query: "froot"
		};
		return matchData;
	}
}