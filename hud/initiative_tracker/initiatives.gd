extends VBoxContainer

signal initiative_changed(new_first)


export(PackedScene) var _initiative_entry_scene: PackedScene
export(PackedScene) var _initiative_20_scene: PackedScene
export(PackedScene) var _new_round_scene: PackedScene


var _new_entries := [ ]



func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("token_spawned", self, "_on_token_spawned")


func _process(_delta: float) -> void:
	if _new_entries.empty():
		set_process(false)
		_new_initiative()
		return
	
	var new_entry: InitiativeEntry = _new_entries.pop_front()
	# warning-ignore:return_value_discarded
	new_entry.connect("token_died", self, "_on_token_died")
	
	if new_entry.token:
		# warning-ignore:return_value_discarded
		new_entry.token.connect("tree_exited", self, "_on_token_died", [ new_entry ])
	
	add_child(new_entry)



func _set_up_initiative(player_initiatives: Dictionary) -> void:
	_clear_initiative()
	
	for player in player_initiatives.keys():
		var token: Token = player
		
		# warning-ignore:unsafe_property_access
		if token.dead or not token.attributes.add_to_initiative:
			continue
		
		var initiative: Attributes.Initiative = player_initiatives[token]
		var new_entry := _initiative_entry_scene.instance() as InitiativeEntry
		
		new_entry.setup(initiative, token)
		_new_entries.append(new_entry)
	
	var monsters := get_tree().get_nodes_in_group(Monsters.MONSTER_GROUP)
	for monster in monsters:
		var token: Token = monster
		
		if token.dead:
			continue
		
		var initiative := token.roll_initiative()
		var new_entry := _initiative_entry_scene.instance() as InitiativeEntry
		
		new_entry.setup(initiative, token)
		_new_entries.append(new_entry)
	
	_new_entries.sort_custom(self, "_sort_entries")
	
	set_process(true)


func _sort_entries(first_entry: InitiativeEntry, second_entry: InitiativeEntry) -> bool:
	if first_entry.initiave.initiative == second_entry.initiave.initiative:
		return first_entry.initiave.modifier >= second_entry.initiave.modifier
	
	return first_entry.initiave.initiative >= second_entry.initiave.initiative


func _clear_initiative() -> void:
	_new_entries.clear()
	
	for entry in get_children():
		remove_child(entry)
		entry.queue_free()
	
	var new_20 := _initiative_20_scene.instance() as InitiativeEntry
	new_20.setup(Attributes.Initiative.new(20, 0), null)
	_new_entries.append(new_20)
	
	var new_round := _new_round_scene.instance() as InitiativeEntry
	new_round.setup(Attributes.Initiative.new(1000, 0), null)
	_new_entries.append(new_round)


func get_current_entry() -> InitiativeEntry:
	var child_count := get_child_count()
	if child_count <= 0:
		return null
	
	return get_child(0) as InitiativeEntry


func _on_done_pressed() -> void:
	var child_count := get_child_count()
	if child_count <= 1:
		return
	
	var old_first := get_current_entry()
	move_child(old_first, child_count - 1)
	old_first.moved()
	
	if old_first.token:
		old_first.token.is_taking_turn = false
	
	_new_initiative()


func _new_initiative() -> void:
	var new_first := get_current_entry()
	emit_signal("initiative_changed", new_first)
	
	if new_first and new_first.token:
		new_first.token.is_taking_turn = true


func _on_token_died(entry: InitiativeEntry) -> void:
	if entry:
		remove_child(entry)
		entry.queue_free()
	
	emit_signal("initiative_changed", get_current_entry())


func _on_attack_pressed() -> void:
	var current_token := get_current_entry().token
	current_token.attack()


func _on_token_spawned(new_token: Token, _at_position: Vector2) -> void:
	# warning-ignore:unsafe_property_access
	if not is_visible_in_tree() or not new_token.attributes.add_to_initiative:
		return
	
	var initiative := new_token.roll_initiative()
	var new_entry := _initiative_entry_scene.instance() as InitiativeEntry
	
	# warning-ignore:return_value_discarded
	new_entry.connect("token_died", self, "_on_token_died")
	new_entry.setup(initiative, new_token)
	
	var children := get_children()
	var child_count := get_child_count()
	var add_at := 0
	
	for index in range(child_count):
		var current_initiative := initiative.initiative
		
		var previous_initiative := 1000
		var previous_entry: InitiativeEntry = null
		
		if index - 1 >= 0:
			previous_entry = children[index - 1]
			previous_initiative = previous_entry.initiave.initiative
		
		var next_initiative := -1000
		var next_entry: InitiativeEntry = null
		
		if index + 1 < child_count:
			next_entry = children[index + 1]
			next_initiative = next_entry.initiave.initiative
		
		if previous_initiative > current_initiative and next_initiative < current_initiative:
			add_at = index
			break
	
	if new_entry.token:
		# warning-ignore:return_value_discarded
		new_entry.token.connect("tree_exited", self, "_on_token_died", [ new_entry ])
	
	add_child(new_entry, true)
	move_child(new_entry, add_at)
	
	_new_initiative()
