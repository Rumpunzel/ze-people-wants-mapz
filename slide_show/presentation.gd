class_name Presentation
extends Control

# warning-ignore-all:unused_signal
signal faded_in
signal faded_out

var current_slide_index: int = -1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slides := get_children()
	if slides.empty():
		return
	
	current_slide_index = 0
	get_current_slide().show()
	
	hide_all_slides()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_RIGHT:
					next_slide()
				KEY_LEFT:
					previous_slide()



func next_slide() -> void:
	if current_slide_index + 1 >= get_child_count():
		return
	
	get_tree().set_input_as_handled()
	var previous_slide := get_current_slide()
	
	current_slide_index += 1
	
	var current_slide := get_current_slide()
	current_slide.display()
	
	yield(current_slide, "faded_in")
	
	if previous_slide:
		previous_slide.hide()


func previous_slide() -> void:
	if current_slide_index <= 0:
		return
	
	get_tree().set_input_as_handled()
	if current_slide_index >= 0:
		get_current_slide().undisplay()
	
	current_slide_index -= 1
	get_current_slide().show()


func hide_all_slides() -> void:
	for index in get_child_count():
		if index == current_slide_index:
			continue
		
		var slide: Slide = get_child(index)
		slide.hide()


func display() -> void:
	var current_slide := get_current_slide()
	
	if visible and current_slide.visible:
		return
	
	current_slide.hide()
	show()
	current_slide.display()
	
	yield(current_slide, "faded_in")
	
	emit_signal("faded_in")


func undisplay() -> void:
	var current_slide := get_current_slide()
	
	if not (visible and current_slide.visible):
		return
	
	current_slide.undisplay()
	
	yield(current_slide, "visibility_changed")
	
	hide()


func get_current_slide() -> Slide:
	return get_child(current_slide_index) as Slide if get_child_count() > current_slide_index else null
