extends HBoxContainer


func _enter_tree() -> void:
	ShittySingleton.connect("new_result", self, "_display_result")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		for child in get_children():
			remove_child(child)
			child.queue_free()


func _display_result(_die: Die, result: int) -> void:
	if result > 0:
		var new_result := Label.new()
		new_result.text = "%d" % result
		add_child(new_result)
		move_child(new_result, 0)
