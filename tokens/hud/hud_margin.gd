tool
extends MarginContainer


var _vertical_offset := Table.GRID_SIZE * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var token: Token = owner
	visible = token.is_visible_in_tree() and not token.dead
	rect_position = token.global_position - rect_pivot_offset - Vector2(0.0, _vertical_offset)


func _on_size_changed(new_size: int) -> void:
	rect_size.x = Table.GRID_SIZE * new_size * Token.SCALE_FACTOR
	rect_pivot_offset = rect_size * 0.5
	_vertical_offset = Table.GRID_SIZE * 0.5 * new_size * Token.SCALE_FACTOR
