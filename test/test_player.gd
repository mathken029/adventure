extends GutTest

var player: Player


func before_each() -> void:
	player = autofree(Player.new())
	add_child_autofree(player)


func test_default_facing_is_down() -> void:
	assert_eq(player.facing, Player.Dir.DOWN)


func test_facing_updates_to_right() -> void:
	player.update_facing(Vector2(1, 0))
	assert_eq(player.facing, Player.Dir.RIGHT)


func test_facing_updates_to_left() -> void:
	player.update_facing(Vector2(-1, 0))
	assert_eq(player.facing, Player.Dir.LEFT)


func test_facing_updates_to_up() -> void:
	player.update_facing(Vector2(0, -1))
	assert_eq(player.facing, Player.Dir.UP)


func test_facing_updates_to_down() -> void:
	player.update_facing(Vector2(0, 1))
	assert_eq(player.facing, Player.Dir.DOWN)


func test_facing_prefers_dominant_axis() -> void:
	player.update_facing(Vector2(0.9, 0.1))
	assert_eq(player.facing, Player.Dir.RIGHT)


func test_idle_walk_column_is_zero() -> void:
	player.walk_time = 0.0
	assert_eq(player.current_walk_column(), 0)


func test_walk_column_cycles_while_moving() -> void:
	# Sample the middle of each animation frame bucket to avoid asserting
	# on exact float boundaries between buckets.
	player.walk_time = Player.WALK_FRAME_TIME * 0.5
	assert_eq(player.current_walk_column(), 1)
	player.walk_time = Player.WALK_FRAME_TIME * 1.5
	assert_eq(player.current_walk_column(), 0)
	player.walk_time = Player.WALK_FRAME_TIME * 2.5
	assert_eq(player.current_walk_column(), 2)
	player.walk_time = Player.WALK_FRAME_TIME * 3.5
	assert_eq(player.current_walk_column(), 0)
