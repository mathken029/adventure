extends Node2D


func _ready() -> void:
	var world := GameWorld.new()
	add_child(world)

	var player := Player.new()
	player.position = Vector2(2.5 * GameWorld.TILE_SIZE, 7.5 * GameWorld.TILE_SIZE)
	add_child(player)

	var camera := Camera2D.new()
	camera.zoom = Vector2(2.5, 2.5)
	player.add_child(camera)
	camera.make_current()

	var map_size := world.get_pixel_size()
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(map_size.x)
	camera.limit_bottom = int(map_size.y)
