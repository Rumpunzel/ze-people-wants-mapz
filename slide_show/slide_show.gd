extends CanvasLayer


var current_presentation_index: int = -1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_presentation()
	
	var presentations := get_children()
	if presentations.empty():
		return
	
	current_presentation_index = 0
	get_current_presentation().show()
	
	hide_all_presentations()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_DOWN:
					next_presentation()
				KEY_UP:
					previous_presentation()
				
				KEY_1:
					start_presentation()
					get_current_presentation().display()
					get_tree().set_input_as_handled()
				KEY_2:
					end_presentation()
					get_current_presentation().undisplay()
					get_tree().set_input_as_handled()



func next_presentation() -> void:
	var previous_presentation := get_current_presentation()
	if current_presentation_index + 1 >= get_child_count() or (previous_presentation and not previous_presentation.visible):
		return
	
	get_tree().set_input_as_handled()
	
	current_presentation_index += 1
	
	var current_presentation := get_current_presentation()
	current_presentation.display()
	
	yield(current_presentation, "faded_in")
	
	if previous_presentation:
		previous_presentation.hide()


func previous_presentation() -> void:
	var previous_presentation := get_current_presentation()
	if current_presentation_index <= 0 or (previous_presentation and not previous_presentation.visible):
		return
	
	get_tree().set_input_as_handled()
	if current_presentation_index >= 0:
		previous_presentation.undisplay()
	
	current_presentation_index -= 1
	get_current_presentation().show()


func start_presentation() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = true


func end_presentation() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false


func hide_all_presentations() -> void:
	for index in get_child_count():
		if index == current_presentation_index:
			continue
		
		var presentation: Presentation = get_child(index)
		presentation.hide()


func get_current_presentation() -> Presentation:
	return get_child(current_presentation_index) as Presentation if get_child_count() > current_presentation_index else null
