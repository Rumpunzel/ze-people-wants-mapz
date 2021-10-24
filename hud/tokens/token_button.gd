extends Button


export(PackedScene) var _token_scene


func _on_pressed() -> void:
	var current_camera: Camera2D = get_tree().get_nodes_in_group("Camera2D").front()
	var new_token: Token = _token_scene.instance()
	var token_position := new_token.as_coordinate(current_camera.global_position)
	
	ShittySingleton.emit_signal("token_spawned", new_token, token_position)
