extends Label


var total := 0 setget set_total


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("new_result", self, "_count_result")


func _count_result(_die: Die, result: int) -> void:
	if result > 0:
		set_total(total + result)


func set_total(new_total: int) -> void:
	total = new_total
	text = "%d" % total
