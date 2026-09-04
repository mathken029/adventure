class_name GameWorld
extends Node2D

const TILE_SIZE := 16

enum Tile { GRASS = 0, PATH = 1, WALL = 2, TREE = 3 }

var tile_map: TileMapLayer
var layout: Array = []


func _ready() -> void:
	layout = build_layout()
	tile_map = TileMapLayer.new()
	tile_map.tile_set = build_tile_set()
	add_child(tile_map)
	paint_map()


func build_layout(width: int = 20, height: int = 15) -> Array:
	var grid := []
	for y in range(height):
		var row := []
		for x in range(width):
			if x == 0 or y == 0 or x == width - 1 or y == height - 1:
				row.append(Tile.WALL)
			else:
				row.append(Tile.GRASS)
		grid.append(row)

	var mid_row := height / 2
	for x in range(1, width - 1):
		grid[mid_row][x] = Tile.PATH

	grid[3][5] = Tile.TREE
	grid[3][6] = Tile.TREE
	grid[height - 4][width - 5] = Tile.TREE

	return grid


func build_tile_set() -> TileSet:
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	tile_set.add_physics_layer()

	var source := TileSetAtlasSource.new()
	source.texture = load("res://assets/tiles/tileset.png")
	source.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)

	for i in range(4):
		source.create_tile(Vector2i(i, 0))

	tile_set.add_source(source, 0)

	var half := TILE_SIZE / 2.0
	var polygon := PackedVector2Array([
		Vector2(-half, -half), Vector2(half, -half),
		Vector2(half, half), Vector2(-half, half),
	])
	for tile in [Tile.WALL, Tile.TREE]:
		var data := source.get_tile_data(Vector2i(tile, 0), 0)
		data.add_collision_polygon(0)
		data.set_collision_polygon_points(0, 0, polygon)

	return tile_set


func paint_map() -> void:
	for y in range(layout.size()):
		for x in range(layout[y].size()):
			var t: int = layout[y][x]
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(t, 0))


func get_pixel_size() -> Vector2:
	if layout.is_empty():
		return Vector2.ZERO
	return Vector2(layout[0].size() * TILE_SIZE, layout.size() * TILE_SIZE)


func is_walkable(cell: Vector2i) -> bool:
	if cell.y < 0 or cell.y >= layout.size():
		return false
	if cell.x < 0 or cell.x >= layout[cell.y].size():
		return false
	var t: int = layout[cell.y][cell.x]
	return t == Tile.GRASS or t == Tile.PATH
