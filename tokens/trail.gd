tool
class_name Trail
extends Line2D


onready var _default_width := width


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	
	var token: Node2D = owner
	width = (token.scale.x / 1.0) * _default_width
	add_point(token.global_position)
	if points.size() > 20:
		remove_point(0)


func set_color(new_color: Color) -> void:
	gradient = gradient.duplicate()
	var alpha_color := new_color
	alpha_color.a = 0.0
	gradient.set_color(0, alpha_color)
	gradient.set_color(1, new_color)
