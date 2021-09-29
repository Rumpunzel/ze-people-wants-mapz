extends Line2D


onready var _label:Label = $Node2D/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_ruler_dismissed()
	
	ShittySingleton.connect("ruler_started", self, "_on_ruler_started")
	ShittySingleton.connect("ruler_ended", self, "_on_ruler_ended")
	ShittySingleton.connect("ruler_dismissed", self, "_on_ruler_dismissed")
	
	_label.add_color_override("font_color", default_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ruler_started(start_position: Vector2) -> void:
	points[0] = start_position
	visible = true

func _on_ruler_ended(end_position: Vector2) -> void:
	points[1] = end_position
	_label.text = "%0.1f ft" % [ points[0].distance_to(points[1]) / 256.0 * 5.0 ]
	_label.rect_pivot_offset = _label.rect_size * 0.5
	_label.rect_position = (points[0] + points[1]) * 0.5 - _label.rect_pivot_offset
	visible = true

func _on_ruler_dismissed() -> void:
	visible = false
