extends Control

const MAIN_SCENE := "res://scenes/main.tscn"

var license_dialog: AcceptDialog


func _ready() -> void:
	custom_minimum_size = get_viewport_rect().size
	anchor_right = 1.0
	anchor_bottom = 1.0

	var bg := ColorRect.new()
	bg.color = Color(0.14, 0.18, 0.22)
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)

	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 24)
	center.add_child(vbox)

	var title := Label.new()
	title.text = "見下ろし型アドベンチャー(仮)"
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var start_button := Button.new()
	start_button.text = "スタート"
	start_button.custom_minimum_size = Vector2(200, 48)
	start_button.pressed.connect(_on_start_pressed)
	vbox.add_child(start_button)

	var license_button := Button.new()
	license_button.text = "ライセンス表記"
	license_button.custom_minimum_size = Vector2(200, 48)
	license_button.pressed.connect(_on_license_pressed)
	vbox.add_child(license_button)

	license_dialog = AcceptDialog.new()
	license_dialog.title = "ライセンス表記"
	license_dialog.size = Vector2(520, 360)
	var label := Label.new()
	label.text = license_text()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.custom_minimum_size = Vector2(480, 0)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(480, 280)
	scroll.add_child(label)
	license_dialog.add_child(scroll)
	add_child(license_dialog)


func license_text() -> String:
	return LicenseNotices.full_text()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_license_pressed() -> void:
	license_dialog.popup_centered()
