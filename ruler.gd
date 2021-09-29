extends Line2D

var _used_manually := false

onready var _label:Label = $Node2D/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_ruler_dismissed()
	
	ShittySingleton.connect("ruler_started", self, "_on_ruler_started")
	ShittySingleton.connect("ruler_ended", self, "_on_ruler_ended")
	ShittySingleton.connect("ruler_dismissed", self, "_on_ruler_dismissed")
	
	_label.add_color_override("font_color", default_color)

func _process(delta: float) -> void:
	if _used_manually:
			_on_ruler_ended(_mouse_as_coordinate(0.0 if Input.is_key_pressed(KEY_CONTROL) else 256.0))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				_used_manually = true
				_on_ruler_started(_mouse_as_coordinate(0.0 if Input.is_key_pressed(KEY_CONTROL) else 256.0))
			else:
				_used_manually = false
				_on_ruler_dismissed()


func _mouse_as_coordinate(grid_snapping := 256.0) -> Vector2:
	var mouse_position := get_global_mouse_position()
	return Vector2(
		stepify(mouse_position.x, grid_snapping),
		stepify(mouse_position.y, grid_snapping)
	)


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
