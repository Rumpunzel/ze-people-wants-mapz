extends HBoxContainer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_I:
					visible = not visible
					get_tree().set_input_as_handled()
