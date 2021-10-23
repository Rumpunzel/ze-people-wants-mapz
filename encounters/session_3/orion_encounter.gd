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
					_spawn_new_orion(_spring.instance())
				
				KEY_8:
					_spawn_new_orion(_summer.instance())
				
				KEY_9:
					_spawn_new_orion(_autumn.instance())
				
				KEY_0:
					_spawn_new_orion(_winter.instance())


func _spawn_new_orion(new_orion: Token) -> void:
	var orion_position := _orion.global_position
	
	remove_child(_orion)
	_orion.queue_free()
	_orion = new_orion
	
	_transformation.global_position = orion_position
	_transformation.emitting = true
	
	ShittySingleton.emit_signal("token_spawned", _orion, orion_position)
	
	get_tree().set_input_as_handled()
