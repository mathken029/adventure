class_name DialogueBox
extends Control

var speaker: String = ""
var lines: Array = []
var index: int = -1

var name_label: Label
var text_label: Label


func _ready() -> void:
	visible = false
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_top = -140
	offset_bottom = -24
	offset_left = 24
	offset_right = -24

	var panel := Panel.new()
	panel.anchor_right = 1.0
	panel.anchor_bottom = 1.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 16)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	name_label = Label.new()
	name_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(name_label)

	text_label = Label.new()
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(text_label)


func is_active() -> bool:
	return index >= 0 and index < lines.size()


func start(speaker_name: String, dialogue_lines: Array) -> void:
	speaker = speaker_name
	lines = dialogue_lines
	index = 0 if lines.size() > 0 else -1
	visible = is_active()
	_refresh_labels()


func advance() -> void:
	if not is_active():
		return
	index += 1
	if index >= lines.size():
		index = -1
		visible = false
		return
	_refresh_labels()


func current_line() -> String:
	if not is_active():
		return ""
	return lines[index]


func _refresh_labels() -> void:
	if name_label and text_label:
		name_label.text = speaker
		text_label.text = current_line()
