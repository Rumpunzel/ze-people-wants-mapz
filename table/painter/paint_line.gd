class_name PaintLine
extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("drawing_deleted", self, "_on_drawing_deleted")


func _on_drawing_deleted() -> void:
	var mouse_position := get_global_mouse_position()
	var squared_width := width * width
	
	for index in range(points.size()-1):
		var closest_point := Geometry.get_closest_point_to_segment_2d(mouse_position, global_position + points[index], global_position + points[index + 1])
		if closest_point.distance_squared_to(mouse_position) <= squared_width:
			get_parent().remove_child(self)
			queue_free()
			return
