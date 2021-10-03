extends YSort

const PLAYER_GROUP := "PLAYERS"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Token:
			child.add_to_group(PLAYER_GROUP)

