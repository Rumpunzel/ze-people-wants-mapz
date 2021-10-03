extends Particles2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var token: Token = owner
	visible = not token.dead
