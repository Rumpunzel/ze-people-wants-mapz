extends LineEdit

export(NodePath) var _use_3d_dice_node_path: NodePath

onready var _use_3d_dice: CheckButton = get_node(_use_3d_dice_node_path)


func _spawn_dice(new_text: String) -> void:
	var commands := new_text.split("d")
	if commands.size() <= 1:
		return
	
	for _i in range(int(max(int(commands[0]), 1))):
		ShittySingleton.left_to_spawn.append(Die.DieToRoll.new(int(commands[1]), _use_3d_dice.pressed))
