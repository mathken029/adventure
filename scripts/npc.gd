class_name NPC
extends StaticBody2D

var character_name: String = "NPC"
var lines: Array = []

var sprite: Sprite2D
var collision: CollisionShape2D


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/npc.png")
	sprite.hframes = Player.HFRAMES
	sprite.vframes = Player.VFRAMES
	sprite.frame = Player.Dir.DOWN * Player.HFRAMES
	add_child(sprite)

	collision = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(14, 10)
	collision.shape = shape
	collision.position = Vector2(0, 6)
	add_child(collision)
