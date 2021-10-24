extends Node2D


export(PackedScene) var _line_scene

var _current_line: PaintLine = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("drawing_started", self, "_on_drawing_started")
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("drawing_ended", self, "_on_drawing_ended")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if _current_line:
			_current_line.add_point(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_drawing_started(color: Color) -> void:
	_current_line = _line_scene.instance()
	_current_line.default_color = color
	
	add_child(_current_line)
	_current_line.add_point(get_global_mouse_position())


func _on_drawing_ended() -> void:
	_current_line = null


func _on_drawing_deleted() -> void:
	pass
