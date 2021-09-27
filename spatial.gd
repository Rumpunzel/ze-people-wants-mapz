extends Spatial

export(PackedScene) var die_scene


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		var dice := get_tree().get_nodes_in_group("Dice")
		
		for die in dice:
			die.get_parent().remove_child(die)
			die.queue_free()


func _process(_delta: float) -> void:
	if ShittySingleton.left_to_spawn > 0:
		var new_die := die_scene.instance() as Die
		var spawn_position = Die.random_vector3() * 2.0
		
		spawn_position.y = 3.0 + randf() * 10.0
		new_die.transform.origin = spawn_position
		
		add_child(new_die)
		
		ShittySingleton.left_to_spawn -= 1
