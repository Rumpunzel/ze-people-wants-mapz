extends LineEdit


export(PackedScene) var die_scene

var _left_to_spawn := 0


func _process(_delta: float) -> void:
	if _left_to_spawn > 0:
		var new_die := die_scene.instance() as Die
		var spawn_position = Die.random_vector3() * 0.9
		
		spawn_position.y = 3.0 + randf() * 3.0
		new_die.transform.origin = spawn_position
		
		add_child(new_die)
		
		_left_to_spawn -= 1


func _spawn_dice(new_text: String) -> void:
	var commands := new_text.split("d")
	_left_to_spawn += int(commands[0])
