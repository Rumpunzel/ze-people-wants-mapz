extends Spatial

export(PackedScene) var d4_scene
export(PackedScene) var d6_scene
export(PackedScene) var d8_scene
export(PackedScene) var d10_scene
export(PackedScene) var d12_scene
export(PackedScene) var d20_scene
export(PackedScene) var d100_scene



func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		var dice := get_tree().get_nodes_in_group("Dice")
		
		for node in dice:
			var die: Die = node
			die.delete()
	
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_1:
					visible = false
				KEY_2:
					visible = true


func _process(_delta: float) -> void:
	if not ShittySingleton.left_to_spawn.empty():
		var die_to_spawn: Die.DieToRoll = ShittySingleton.left_to_spawn.pop_front()
		var new_die: Die
		
		if die_to_spawn.use_3d_dice:
			match die_to_spawn.die_type:
				Die.DiceTypes.d4:
					new_die = d4_scene.instance()
				Die.DiceTypes.d6:
					new_die = d6_scene.instance()
				Die.DiceTypes.d8:
					new_die = d8_scene.instance()
				Die.DiceTypes.d10:
					new_die = d10_scene.instance()
				Die.DiceTypes.d12:
					new_die = d12_scene.instance()
				Die.DiceTypes.d20:
					new_die = d20_scene.instance()
				Die.DiceTypes.d100:
					new_die = d100_scene.instance()
			
		if not new_die:
			ShittySingleton.display_result(die_to_spawn.die_type, Die.roll(1, die_to_spawn.die_type))
			return
		
		var spawn_position = Die.random_vector3() * 10.0
		
		spawn_position.y = 10.0 + randf() * 10.0
		new_die.transform.origin = spawn_position
		
		if die_to_spawn.damage_type >= 0:
			var damage_name := ""
			
			if die_to_spawn.damage_type < Attack.PhysicalDamageTypes.SLASHING:
				damage_name = Attack.PhysicalDamageTypes.keys()[ Attack.PhysicalDamageTypes.values().find(die_to_spawn.damage_type) ].to_lower()
			else:
				damage_name = Attack.MagicalDamageTypes.keys()[ Attack.MagicalDamageTypes.values().find(die_to_spawn.damage_type) ].to_lower()
			
			new_die.setup(die_to_spawn.damage_type, damage_name)
		
		add_child(new_die)
