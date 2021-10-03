class_name Monsters
extends YSort

const MONSTER_GROUP := "MONSTERS"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Token:
			child.add_to_group(MONSTER_GROUP)
