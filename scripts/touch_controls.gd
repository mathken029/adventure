class_name TouchControls
extends CanvasLayer

signal move_input_changed(vector: Vector2)
signal interact_pressed

var held := {"up": false, "down": false, "left": false, "right": false}


func _ready() -> void:
	layer = 10
	visible = DisplayServer.is_touchscreen_available()

	var dpad_origin := Vector2(24, -224)
	_add_dir_button("↑", dpad_origin + Vector2(64, 0), "up")
	_add_dir_button("←", dpad_origin + Vector2(0, 64), "left")
	_add_dir_button("↓", dpad_origin + Vector2(64, 128), "down")
	_add_dir_button("→", dpad_origin + Vector2(128, 64), "right")

	var interact := _make_button("話す", Vector2(64, 64))
	interact.anchor_left = 1.0
	interact.anchor_right = 1.0
	interact.anchor_top = 1.0
	interact.anchor_bottom = 1.0
	interact.offset_left = -104
	interact.offset_right = -24
	interact.offset_top = -104
	interact.offset_bottom = -24
	interact.button_down.connect(func() -> void: interact_pressed.emit())
	add_child(interact)


func set_held(direction: String, value: bool) -> void:
	held[direction] = value
	move_input_changed.emit(current_vector())


func current_vector() -> Vector2:
	var v := Vector2.ZERO
	if held["left"]:
		v.x -= 1
	if held["right"]:
		v.x += 1
	if held["up"]:
		v.y -= 1
	if held["down"]:
		v.y += 1
	return v


func _add_dir_button(label: String, offset: Vector2, direction: String) -> void:
	var button := _make_button(label, Vector2(56, 56))
	button.anchor_left = 0.0
	button.anchor_right = 0.0
	button.anchor_top = 1.0
	button.anchor_bottom = 1.0
	button.offset_left = offset.x
	button.offset_right = offset.x + 56
	button.offset_top = offset.y
	button.offset_bottom = offset.y + 56
	button.button_down.connect(func() -> void: set_held(direction, true))
	button.button_up.connect(func() -> void: set_held(direction, false))
	add_child(button)


func _make_button(label: String, size: Vector2) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = size
	button.focus_mode = Control.FOCUS_NONE
	button.modulate = Color(1, 1, 1, 0.75)
	return button
