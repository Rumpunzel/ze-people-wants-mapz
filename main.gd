extends Node

export var _run_as_session := true


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	randomize()
	
	if _run_as_session:
		OS.current_screen = OS.get_screen_count() - 1
		OS.window_fullscreen = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
