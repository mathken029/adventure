extends GutTest

var controls: TouchControls


func before_each() -> void:
	controls = autofree(TouchControls.new())


func test_initial_vector_is_zero() -> void:
	assert_eq(controls.current_vector(), Vector2.ZERO)


func test_holding_right_gives_positive_x() -> void:
	controls.set_held("right", true)
	assert_eq(controls.current_vector(), Vector2(1, 0))


func test_holding_left_and_up_combines() -> void:
	controls.set_held("left", true)
	controls.set_held("up", true)
	assert_eq(controls.current_vector(), Vector2(-1, -1))


func test_releasing_direction_resets_axis() -> void:
	controls.set_held("down", true)
	controls.set_held("down", false)
	assert_eq(controls.current_vector(), Vector2.ZERO)


func test_set_held_emits_move_input_changed() -> void:
	watch_signals(controls)
	controls.set_held("up", true)
	assert_signal_emitted_with_parameters(controls, "move_input_changed", [Vector2(0, -1)])
