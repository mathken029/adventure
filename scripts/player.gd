class_name Player
extends CharacterBody2D

const SPEED := 100.0
const FRAME_SIZE := 32
const HFRAMES := 3
const VFRAMES := 4
const WALK_FRAME_TIME := 0.15

enum Dir { DOWN = 0, LEFT = 1, RIGHT = 2, UP = 3 }

var facing: int = Dir.DOWN
var walk_time: float = 0.0
var movement_enabled: bool = true
var touch_input_vector: Vector2 = Vector2.ZERO

var sprite: Sprite2D
var collision: CollisionShape2D


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/player.png")
	sprite.hframes = HFRAMES
	sprite.vframes = VFRAMES
	add_child(sprite)

	collision = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(14, 10)
	collision.shape = shape
	collision.position = Vector2(0, 6)
	add_child(collision)

	_update_sprite_frame(0)


func _physics_process(delta: float) -> void:
	if not movement_enabled:
		walk_time = 0.0
		velocity = Vector2.ZERO
		move_and_slide()
		_update_sprite_frame(0)
		return

	var input_vector := get_input_vector()
	var moving := input_vector.length() > 0.0

	if moving:
		input_vector = input_vector.normalized()
		update_facing(input_vector)
		walk_time += delta
	else:
		walk_time = 0.0

	velocity = input_vector * SPEED
	move_and_slide()
	_update_sprite_frame(current_walk_column())


func get_input_vector() -> Vector2:
	var v := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		v.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		v.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		v.y += 1
	v += touch_input_vector
	v.x = clampf(v.x, -1.0, 1.0)
	v.y = clampf(v.y, -1.0, 1.0)
	return v


func update_facing(v: Vector2) -> void:
	if absf(v.x) > absf(v.y):
		facing = Dir.RIGHT if v.x > 0.0 else Dir.LEFT
	else:
		facing = Dir.DOWN if v.y > 0.0 else Dir.UP


func current_walk_column() -> int:
	if walk_time <= 0.0:
		return 0
	var cycle := [1, 0, 2, 0]
	var step := int(walk_time / WALK_FRAME_TIME) % cycle.size()
	return cycle[step]


func _update_sprite_frame(column: int) -> void:
	if sprite:
		sprite.frame = facing * HFRAMES + column
