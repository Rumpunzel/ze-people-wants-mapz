extends PopupPanel


var _being_dragged := false
var _offset := Vector2.ZERO


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			_being_dragged = mouse_event.pressed
			
			if mouse_event.pressed:
				_offset = get_global_mouse_position() - rect_position
			
			get_tree().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_R:
					if not visible:
						popup_centered()
						get_tree().set_input_as_handled()


func _process(_delta: float):
	if _being_dragged:
		rect_position = get_global_mouse_position() - _offset
