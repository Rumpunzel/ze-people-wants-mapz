class_name Monsters
extends YSort

const MONSTER_GROUP := "MONSTERS"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Token:
			child.add_to_group(MONSTER_GROUP)
	
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("token_spawned", self, "_on_token_spawned")


func _on_token_spawned(new_token: Token, at_position: Vector2) -> void:
	new_token.add_to_group(MONSTER_GROUP)
	add_child(new_token, true)
	new_token.global_position = at_position
