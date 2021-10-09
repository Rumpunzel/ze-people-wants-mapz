extends Node

# warning-ignore-all:unused_signal
signal new_result(die, new_result)

signal ruler_started(position)
signal ruler_ended(position)
signal ruler_dismissed()

signal single_target_dialog_openend(token)
signal multi_target_dialog_done(amount, magical, damage_type, damage_type_string, dc, saving_throw_to_make, to_take)

signal drawing_started(color)
signal drawing_ended()
signal drawing_deleted()

signal token_spawned(new_token)


# warning-ignore:unused_class_variable
var left_to_spawn := [ ]


func display_result(die: int, result: int) -> void:
	emit_signal("new_result", die, result)
