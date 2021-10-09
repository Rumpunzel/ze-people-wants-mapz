extends Node

# warning-ignore-all:unused_signal
signal new_result(die, new_result)

signal ruler_started(position)
signal ruler_ended(position)
signal ruler_dismissed()

signal single_target_dialog_openend(token)

signal drawing_started(color)
signal drawing_ended()
signal drawing_deleted()


# warning-ignore:unused_class_variable
var left_to_spawn := [ ]


func display_result(die: int, result: int) -> void:
	emit_signal("new_result", die, result)
