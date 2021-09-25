extends Spatial

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		var dice := get_tree().get_nodes_in_group("Dice")
		
		for die in dice:
			die.get_parent().remove_child(die)
			die.queue_free()
