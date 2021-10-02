extends Label


var total := 0


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("new_result", self, "_count_result")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		total = 0
		text = "Total: %d" % total


func _count_result(_die: Die, result: int) -> void:
	if result > 0:
		total += result
		text = "Total: %d" % total
