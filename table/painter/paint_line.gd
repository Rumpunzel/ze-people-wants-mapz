class_name PaintLine
extends Line2D


var _being_dragged := false
var _first_mouse_position: Vector2
var _original_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("drawing_deleted", self, "_on_drawing_deleted")


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventMouseButton:
		var closest_point =  _mouse_on_line()
		if not closest_point:
			return
		
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			_original_position = position
			_first_mouse_position = get_global_mouse_position()
			_being_dragged = mouse_event.pressed
			get_tree().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			if not mouse_event.pressed:
				_being_dragged = false


func _process(_delta: float):
	if _being_dragged:
		position = _original_position + get_global_mouse_position() - _first_mouse_position



func _on_drawing_deleted() -> void:
	if _mouse_on_line():
		get_parent().remove_child(self)
		queue_free()


func _mouse_on_line() -> bool:
	var mouse_position := get_global_mouse_position()
	var squared_width := width * width
	
	for index in range(points.size()-1):
		var closest_point := Geometry.get_closest_point_to_segment_2d(mouse_position, global_position + points[index], global_position + points[index + 1])
		if closest_point.distance_squared_to(mouse_position) <= squared_width:
			return true
	
	return false
