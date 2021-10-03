extends Spatial

export(PackedScene) var d4_scene
export(PackedScene) var d6_scene
export(PackedScene) var d8_scene
export(PackedScene) var d10_scene
export(PackedScene) var d12_scene
export(PackedScene) var d20_scene
export(PackedScene) var d100_scene


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		var dice := get_tree().get_nodes_in_group("Dice")
		
		for die in dice:
			die.get_parent().remove_child(die)
			die.queue_free()


func _process(_delta: float) -> void:
	if not ShittySingleton.left_to_spawn.empty():
		var dice_to_spawn: int = ShittySingleton.left_to_spawn.pop_front()
		var new_die: Die
		
		match dice_to_spawn:
			Die.DiceTypes.d4:
				new_die = d4_scene.instance()
			Die.DiceTypes.d6:
				new_die = d6_scene.instance()
			Die.DiceTypes.d8:
				new_die = d8_scene.instance()
			Die.DiceTypes.d10:
				new_die = d10_scene.instance()
			Die.DiceTypes.d12:
				new_die = d12_scene.instance()
			Die.DiceTypes.d20:
				new_die = d20_scene.instance()
			Die.DiceTypes.d100:
				new_die = d100_scene.instance()
			
			0:
				return
			_:
				ShittySingleton.display_result(null, 1 + randi() % dice_to_spawn)
				return
		
		var spawn_position = Die.random_vector3() * 10.0
		
		spawn_position.y = 10.0 + randf() * 10.0
		new_die.transform.origin = spawn_position
		
		add_child(new_die)
