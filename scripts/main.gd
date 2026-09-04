extends Node2D

const INTERACT_RANGE := 24.0

var player: Player
var npc: NPC
var dialogue_box: DialogueBox

var _interact_prev := false


func _ready() -> void:
	var world := GameWorld.new()
	add_child(world)

	player = Player.new()
	player.position = Vector2(2.5 * GameWorld.TILE_SIZE, 7.5 * GameWorld.TILE_SIZE)
	add_child(player)

	npc = NPC.new()
	npc.character_name = "村人"
	npc.lines = [
		"やあ、旅人!",
		"この村には見下ろし型のアドベンチャーが伝わっているんだ。",
		"道なりに進めば、きっと何か見つかるはずさ。",
	]
	npc.position = Vector2(10.5 * GameWorld.TILE_SIZE, 7.5 * GameWorld.TILE_SIZE)
	add_child(npc)

	var camera := Camera2D.new()
	camera.zoom = Vector2(2.5, 2.5)
	player.add_child(camera)
	camera.make_current()

	var map_size := world.get_pixel_size()
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(map_size.x)
	camera.limit_bottom = int(map_size.y)

	var ui_layer := CanvasLayer.new()
	add_child(ui_layer)
	dialogue_box = DialogueBox.new()
	ui_layer.add_child(dialogue_box)

	var touch_controls := TouchControls.new()
	add_child(touch_controls)
	touch_controls.move_input_changed.connect(func(v: Vector2) -> void: player.touch_input_vector = v)
	touch_controls.interact_pressed.connect(_do_interact)


func _process(_delta: float) -> void:
	var interact_now := (
		Input.is_key_pressed(KEY_E)
		or Input.is_key_pressed(KEY_SPACE)
		or Input.is_key_pressed(KEY_ENTER)
	)
	var interact_just_pressed := interact_now and not _interact_prev
	_interact_prev = interact_now

	if interact_just_pressed:
		_do_interact()


func _do_interact() -> void:
	if dialogue_box.is_active():
		dialogue_box.advance()
	elif player.global_position.distance_to(npc.global_position) <= INTERACT_RANGE:
		dialogue_box.start(npc.character_name, npc.lines)

	player.movement_enabled = not dialogue_box.is_active()
