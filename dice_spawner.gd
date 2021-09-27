extends LineEdit


func _spawn_dice(new_text: String) -> void:
	var commands := new_text.split("d")
	ShittySingleton.left_to_spawn += int(commands[0])
