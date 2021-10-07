extends LineEdit


func _spawn_dice(new_text: String) -> void:
	var commands := new_text.split("d")
	
	for _i in range(int(max(int(commands[0]), 1))):
		ShittySingleton.left_to_spawn.append(Die.DieToRoll.new(int(commands[1])))
