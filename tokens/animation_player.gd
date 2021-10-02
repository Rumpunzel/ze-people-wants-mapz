extends AnimationPlayer

export(float, 0.0, 1.0) var _animation_speed_randomness := 0.0

func _on_animation_started(new_anim_name: String) -> void:
	var new_anim := get_animation(new_anim_name)
	if new_anim.loop:
		playback_speed = 1.0 + randf() * _animation_speed_randomness - _animation_speed_randomness * 0.5
		seek(randf() * new_anim.length)
