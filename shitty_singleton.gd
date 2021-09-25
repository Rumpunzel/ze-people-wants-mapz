extends Node

signal new_result(die, new_result)

func display_result(die: Die, result: int) -> void:
	emit_signal("new_result", die, result)
