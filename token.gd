extends KinematicBody2D


export var _move_speed := 2.0
export var _max_travel_time = 0.6

var _being_dragged := false setget _set_being_dragged

onready var _ghost: Sprite = $Background.duplicate()
onready var _ghost_tween: Tween = $GhostTween
onready var _movement_tween: Tween = $MovementTween



func _ready() -> void:
	_ghost.get_node("MarginContainer/Image").light_mask = 5
	_ghost.get_node("Mask").range_item_cull_mask = 4
	_ghost.modulate.a = 0.5
	_ghost.visible = false
	
	add_child(_ghost)


func _process(_delta: float):
	if _being_dragged:
		var mouse_position := get_viewport().get_mouse_position()
		var raster_position := Vector2(
			stepify(mouse_position.x, 256.0),
			stepify(mouse_position.y, 256.0)
		)
		
		_ghost_tween.interpolate_property(_ghost, "global_position", null, raster_position, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		_ghost_tween.start()


func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			_set_being_dragged(event.pressed)
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.global_position = event.get_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			_set_being_dragged(false)



func _set_being_dragged(new_status: bool) -> void:
	_being_dragged = new_status
	
	if _being_dragged:
		if not _ghost.visible:
			_ghost.global_position = global_position
			_ghost.visible = true
	else:
		if _ghost.visible:
			_ghost.visible = false
			
			var travel_time := min(global_position.distance_to(_ghost.global_position) / (_move_speed * 512.0) , _max_travel_time)
			_movement_tween.interpolate_property(self, "global_position", null, _ghost.global_position, travel_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
			_movement_tween.start()
