extends Line2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gradient = gradient.duplicate()
	var alpha_color := default_color
	alpha_color.a = 0.0
	gradient.set_color(0, alpha_color)
	gradient.set_color(1, default_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	add_point(owner.position)
	if points.size() > 20:
		remove_point(0)
