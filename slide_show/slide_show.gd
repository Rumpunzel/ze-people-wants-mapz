extends CanvasLayer


var current_slide_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slides := get_children()
	if slides.empty():
		return
	
	current_slide_index = 0
	get_current_slide().show()
	
	hide_all_slides()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_RIGHT:
					next_slide()
					get_tree().set_input_as_handled()
				KEY_LEFT:
					previous_slide()
					get_tree().set_input_as_handled()
				
				KEY_2:
					get_current_slide().undisplay()
					get_tree().set_input_as_handled()
				KEY_1:
					get_current_slide().display()
					get_tree().set_input_as_handled()



func next_slide() -> void:
	if current_slide_index + 1 >= get_child_count():
		return
	
	var previous_slide := get_current_slide()
	
	current_slide_index += 1
	
	var current_slide := get_current_slide()
	current_slide.display()
	
	yield(previous_slide, "visibility_changed")
	
	if previous_slide:
		previous_slide.hide()


func previous_slide() -> void:
	if current_slide_index <= 0:
		return
	
	if current_slide_index >= 0:
		get_current_slide().undisplay()
	
	current_slide_index -= 1
	get_current_slide().show()


func hide_all_slides() -> void:
	var slides := get_children()
	for child in slides:
		var slide: Slide = child
		
		if slides.find(slide) == current_slide_index:
			continue
		
		slide.hide()


func get_current_slide() -> Slide:
	return get_child(current_slide_index) as Slide if get_child_count() > current_slide_index else null
