extends Button


export(PackedScene) var _token_scene


func _on_pressed() -> void:
	ShittySingleton.emit_signal("token_spawned", _token_scene.instance(), Vector2.ZERO)
