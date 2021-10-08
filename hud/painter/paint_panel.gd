extends MarginContainer

var _pen_color := Color.black

onready var _color_picker: ColorPicker = $VBoxContainer/Color/Popup/MarginContainer/VBoxContainer/ColorPicker


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
					
					get_tree().set_input_as_handled()


func _on_color_accept_pressed() -> void:
	_pen_color = _color_picker.color
	print(_pen_color)
