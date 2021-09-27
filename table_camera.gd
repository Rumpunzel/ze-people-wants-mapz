extends Camera2D

export var _inverted := false
export var _zoom_factor := 0.1

var _being_dragged := false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			_being_dragged = event.pressed
		
		elif event.button_index == BUTTON_WHEEL_UP:
			zoom -= Vector2(_zoom_factor, _zoom_factor)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom += Vector2(_zoom_factor, _zoom_factor)
	
	elif event is InputEventMouseMotion:
		if _being_dragged:
			position += event.relative * (1.0 if _inverted else -1.0) * zoom.length()
