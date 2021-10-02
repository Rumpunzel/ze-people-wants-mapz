tool
extends MarginContainer


var _vertical_offset := 128.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var token: Node2D = owner
	visible = token.is_visible_in_tree()
	rect_position = token.global_position - rect_pivot_offset - Vector2(0.0, _vertical_offset)


func _on_size_changed(new_size: int) -> void:
	rect_size.x = 256.0 * new_size * Token.SCALE_FACTOR
	rect_pivot_offset = rect_size * 0.5
	_vertical_offset = 128.0 * new_size * Token.SCALE_FACTOR
