extends MarginContainer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_T:
					if not visible:
						show()
					else:
						hide()
					
					get_tree().set_input_as_handled()
