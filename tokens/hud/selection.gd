extends Sprite

onready var _base_scale := scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var token: Token = owner
	global_position = token.global_position
	scale = _base_scale * token.scale.x
