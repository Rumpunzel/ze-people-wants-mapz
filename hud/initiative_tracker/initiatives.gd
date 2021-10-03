extends VBoxContainer

signal initiative_changed(new_first)


export(PackedScene) var _initiative_entry_scene: PackedScene
export(PackedScene) var _initiative_20_scene: PackedScene
export(PackedScene) var _new_round_scene: PackedScene


var _new_entries := [ ]



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_I:
					_set_up_initiative()


func _process(_delta: float) -> void:
	if _new_entries.empty():
		set_process(false)
		_new_initiative()
		return
	
	add_child(_new_entries.pop_front())



func _set_up_initiative() -> void:
	_clear_initiative()
	
	var players := get_tree().get_nodes_in_group(Players.PLAYER_GROUP)
	for player in players:
		var token: Token = player
		var initiative := token.roll_initiative()
		var new_entry := _initiative_entry_scene.instance() as InitiativeEntry
		
		new_entry.setup(initiative, token)
		_new_entries.append(new_entry)
	
	var monsters := get_tree().get_nodes_in_group(Monsters.MONSTER_GROUP)
	for monster in monsters:
		var token: Token = monster
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
		old_first.token.selected = false
	
	_new_initiative()


func _new_initiative() -> void:
	var new_first := get_current_entry()
	emit_signal("initiative_changed", new_first)
	if new_first and new_first.token:
		new_first.token.selected = true


func _on_die_pressed() -> void:
	var current_entry := get_current_entry()
	if not current_entry:
		return
	
	current_entry.token.die()
	remove_child(current_entry)
	current_entry.queue_free()
	emit_signal("initiative_changed", get_current_entry())
