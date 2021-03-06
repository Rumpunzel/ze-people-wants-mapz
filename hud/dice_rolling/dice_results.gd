extends RichTextLabel


export var _crit_color := Color.green
export var _crit_miss := Color.red


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("new_result", self, "_display_result")


func _display_result(die: int, result: int) -> void:
	if result > 0:
		var special_result := result == die or result == 1
		var color_begin := "[color=#%s]" % [ _crit_color.to_html() if result == die else _crit_miss.to_html() ] if special_result else ""
		var color_end := "[/color]" if special_result else ""
		var prefix :=  "" if text.empty() else ", "
		
		# warning-ignore:return_value_discarded
		append_bbcode("%s%s%d%s" % [ prefix, color_begin, result, color_end ])
