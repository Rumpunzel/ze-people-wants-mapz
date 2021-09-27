extends Camera2D

var _inverted := false

var _being_dragged := false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			_being_dragged = event.pressed
	
	if _being_dragged and event is InputEventMouseMotion:
		position += event.relative * (1.0 if _inverted else -1.0)
