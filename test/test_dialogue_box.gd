extends GutTest

var box: DialogueBox


func before_each() -> void:
	box = autofree(DialogueBox.new())


func test_inactive_before_start() -> void:
	assert_false(box.is_active())


func test_start_activates_and_shows_first_line() -> void:
	box.start("村人", ["こんにちは", "また会おう"])
	assert_true(box.is_active())
	assert_eq(box.current_line(), "こんにちは")


func test_advance_moves_to_next_line() -> void:
	box.start("村人", ["こんにちは", "また会おう"])
	box.advance()
	assert_true(box.is_active())
	assert_eq(box.current_line(), "また会おう")


func test_advance_past_last_line_ends_dialogue() -> void:
	box.start("村人", ["ひとこと"])
	box.advance()
	assert_false(box.is_active())
	assert_eq(box.current_line(), "")


func test_start_with_empty_lines_is_inactive() -> void:
	box.start("村人", [])
	assert_false(box.is_active())


func test_advance_while_inactive_is_a_no_op() -> void:
	box.advance()
	assert_false(box.is_active())
