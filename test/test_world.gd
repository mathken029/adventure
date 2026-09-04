extends GutTest

var world: GameWorld


func before_each() -> void:
	world = autofree(GameWorld.new())


func test_layout_has_requested_dimensions() -> void:
	var layout := world.build_layout(20, 15)
	assert_eq(layout.size(), 15)
	assert_eq(layout[0].size(), 20)


func test_border_is_wall() -> void:
	var layout := world.build_layout(10, 8)
	for x in range(10):
		assert_eq(layout[0][x], GameWorld.Tile.WALL)
		assert_eq(layout[7][x], GameWorld.Tile.WALL)
	for y in range(8):
		assert_eq(layout[y][0], GameWorld.Tile.WALL)
		assert_eq(layout[y][9], GameWorld.Tile.WALL)


func test_interior_has_walkable_path() -> void:
	world.layout = world.build_layout(20, 15)
	var mid_row := 15 / 2
	assert_eq(world.layout[mid_row][10], GameWorld.Tile.PATH)
	assert_true(world.is_walkable(Vector2i(10, mid_row)))


func test_wall_is_not_walkable() -> void:
	world.layout = world.build_layout(20, 15)
	assert_false(world.is_walkable(Vector2i(0, 0)))


func test_out_of_bounds_is_not_walkable() -> void:
	world.layout = world.build_layout(20, 15)
	assert_false(world.is_walkable(Vector2i(-1, 0)))
	assert_false(world.is_walkable(Vector2i(999, 999)))


func test_pixel_size_matches_layout() -> void:
	world.layout = world.build_layout(20, 15)
	var size := world.get_pixel_size()
	assert_eq(size, Vector2(20 * GameWorld.TILE_SIZE, 15 * GameWorld.TILE_SIZE))
