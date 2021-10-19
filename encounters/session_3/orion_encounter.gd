extends Monsters


export(PackedScene) var _spring: PackedScene
export(PackedScene) var _summer: PackedScene
export(PackedScene) var _autumn: PackedScene
export(PackedScene) var _winter: PackedScene

onready var _orion: Token = $Orion
onready var _transformation: Particles2D = $Transformation


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			if not _orion:
				return
			
			match(key_event.scancode):
				
				KEY_7:
					var new_orion: Token = _spring.instance()
					var orion_position := _orion.global_position
					
					remove_child(_orion)
					_orion.queue_free()
					_orion = new_orion
					
					_transformation.global_position = orion_position
					_transformation.emitting = true
					
					ShittySingleton.emit_signal("token_spawned", _orion)
					_orion.global_position = orion_position
					
					get_tree().set_input_as_handled()
				
				
				KEY_8:
					var new_orion: Token = _summer.instance()
					var orion_position := _orion.global_position
					
					remove_child(_orion)
					_orion.queue_free()
					_orion = new_orion
					
					_transformation.global_position = orion_position
					_transformation.emitting = true
					
					ShittySingleton.emit_signal("token_spawned", _orion)
					_orion.global_position = orion_position
					
					get_tree().set_input_as_handled()
				
				
				KEY_9:
					var new_orion: Token = _autumn.instance()
					var orion_position := _orion.global_position
					
					remove_child(_orion)
					_orion.queue_free()
					_orion = new_orion
					
					_transformation.global_position = orion_position
					_transformation.emitting = true
					
					ShittySingleton.emit_signal("token_spawned", _orion)
					_orion.global_position = orion_position
					
					get_tree().set_input_as_handled()
				
				
				KEY_0:
					var new_orion: Token = _winter.instance()
					var orion_position := _orion.global_position
					
					remove_child(_orion)
					_orion.queue_free()
					_orion = new_orion
					
					_transformation.global_position = orion_position
					_transformation.emitting = true
					
					ShittySingleton.emit_signal("token_spawned", _orion)
					_orion.global_position = orion_position
					
					get_tree().set_input_as_handled()
