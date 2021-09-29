extends Node

signal new_result(die, new_result)

signal ruler_started(position)
signal ruler_ended(position)
signal ruler_dismissed()


var left_to_spawn := 0


func display_result(die: Die, result: int) -> void:
	emit_signal("new_result", die, result)
