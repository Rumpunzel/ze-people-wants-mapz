extends Line2D


var _used_manually := false

onready var _default_color := default_color
onready var _label: Label = $CanvasLayer/Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_ruler_dismissed()
	
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("ruler_started", self, "_on_ruler_started")
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("ruler_ended", self, "_on_ruler_ended")
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("ruler_dismissed", self, "_on_ruler_dismissed")


func _process(_delta: float) -> void:
	if _used_manually:
			_on_ruler_ended(_mouse_as_coordinate(0.0 if Input.is_key_pressed(KEY_CONTROL) else Table.GRID_SIZE * 0.5))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_RIGHT:
			if mouse_event.pressed:
				_used_manually = true
				_on_ruler_started(_mouse_as_coordinate(0.0 if Input.is_key_pressed(KEY_CONTROL) else Table.GRID_SIZE * 0.5), _default_color)
			else:
				_used_manually = false
				_on_ruler_dismissed()



func _mouse_as_coordinate(grid_snapping := Table.GRID_SIZE * 0.5) -> Vector2:
	var mouse_position := get_global_mouse_position() - Vector2(Table.GRID_SIZE, Table.GRID_SIZE) * 0.5
	return Vector2(
		stepify(mouse_position.x, grid_snapping),
		stepify(mouse_position.y, grid_snapping)
	) + Vector2(Table.GRID_SIZE, Table.GRID_SIZE) * 0.5


func _on_ruler_started(start_position: Vector2, color: Color) -> void:
	default_color = color if not color == Color.transparent else _default_color
	_label.add_color_override("font_color", default_color)
	
	var outline_color := Color.slategray if color.r + color.g + color.b > 1.75 else Color.whitesmoke
	_label.add_color_override("font_outline_modulate", outline_color)
	
	points[0] = start_position
	visible = true
	_label.visible = visible


func _on_ruler_ended(end_position: Vector2) -> void:
	points[1] = end_position
	_label.text = "%0.1f ft" % [ points[0].distance_to(points[1]) / Table.GRID_SIZE * 5.0 ]
	_label.rect_pivot_offset = _label.rect_size * 0.5
	
	var current_camera: Camera2D = get_tree().get_nodes_in_group("Camera2D").front()
	var viewport_offset: Vector2 = get_viewport().size * 0.5
	_label.rect_position = ((points[0] + points[1]) * 0.5 - current_camera.position) / current_camera.zoom.x + viewport_offset - _label.rect_pivot_offset
	
	visible = true
	_label.visible = visible


func _on_ruler_dismissed() -> void:
	visible = false
	_label.visible = visible
