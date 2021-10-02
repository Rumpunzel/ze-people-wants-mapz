extends Camera2D

export var _inverted := false
export var _zoom_factor := 0.1

var _being_dragged := false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT or mouse_event.button_index == BUTTON_MIDDLE:
			_being_dragged = mouse_event.pressed
		
		elif mouse_event.button_index == BUTTON_WHEEL_UP:
			zoom = Vector2(max(zoom.x - _zoom_factor, _zoom_factor), max(zoom.y - _zoom_factor, _zoom_factor))
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN:
			zoom += Vector2(_zoom_factor, _zoom_factor)
	
	elif event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		if _being_dragged:
			position += motion_event.relative * (1.0 if _inverted else -1.0) * zoom.length()
