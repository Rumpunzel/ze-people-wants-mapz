extends Node

# warning-ignore-all:unused_signal
signal new_result(die, new_result)

signal ruler_started(position)
signal ruler_ended(position)
signal ruler_dismissed()

signal single_target_dialog_openend(token)


# warning-ignore:unused_class_variable
var left_to_spawn := [ ]


func display_result(die: int, result: int) -> void:
	emit_signal("new_result", die, result)
