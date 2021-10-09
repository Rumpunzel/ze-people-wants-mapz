extends MarginContainer


var _pen_color := Color.black

onready var _paint_button: Button = $VBoxContainer/Paint
onready var _erase_button: Button = $VBoxContainer/Erase


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_P:
					if not visible:
						show()
					else:
						hide()
						_paint_button.pressed = false
						_erase_button.pressed = false
					
					get_tree().set_input_as_handled()
	
	
	elif event is InputEventMouseButton:
		if visible:
			if event is InputEventMouseButton:
				var mouse_event: InputEventMouseButton = event
				if mouse_event.button_index == BUTTON_LEFT:
					if _paint_button.pressed:
						if mouse_event.pressed:
							ShittySingleton.emit_signal("drawing_started", _pen_color)
						else:
							ShittySingleton.emit_signal("drawing_ended")
						
						get_tree().set_input_as_handled()
					
					elif _erase_button.pressed:
						if mouse_event.pressed:
							ShittySingleton.emit_signal("drawing_deleted")
							get_tree().set_input_as_handled()
				
				elif mouse_event.button_index == BUTTON_RIGHT:
					_paint_button.pressed = false
					_erase_button.pressed = false
					ShittySingleton.emit_signal("drawing_ended")
					get_tree().set_input_as_handled()


func _on_color_changed(color: Color) -> void:
	_pen_color = color
