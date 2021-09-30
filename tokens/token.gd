tool
class_name Token
extends Area2D

enum Size {
	TINY = 1,
	SMALL = 2,
	MEDIUM = 4,
	LARGE = 8,
	HUGE = 16,
	GARGANTUAN = 32,
}


const SCALE_FACTOR := 0.25


signal size_changed(new_size)
signal maximum_hit_points_changed(new_hit_points)


export var _move_speed := 2.0
export var _max_travel_time = 0.6

export(Size) var _size := Size.MEDIUM setget _set_size
export(Resource) var _attributes = Attributes.new()


var _being_dragged := false setget _set_being_dragged
var _token_offset := Vector2.ZERO

onready var _background: Sprite = $Background
onready var _image: TextureRect = $Image
onready var _ghost_tween: Tween = $GhostTween
onready var _movement_tween: Tween = $MovementTween

onready var _ghost: Node2D = Node2D.new()



func _ready() -> void:
	_set_size(_size)
	
	emit_signal("maximum_hit_points_changed", _attributes.calculate_hit_points())
	
	if Engine.editor_hint:
		return
	
	var ghost_background := _background.duplicate()
	ghost_background.visible = _background.visible
	_ghost.add_child(ghost_background)
	
	var ghost_image := _image.duplicate()
	_ghost.add_child(ghost_image)
	
	_ghost.modulate.a = 0.5
	_ghost.visible = false
	_ghost.z_index = 5
	
	add_child(_ghost)


func _process(_delta: float):
	if Engine.editor_hint:
		return
	
	if _being_dragged:
		_ghost_tween.interpolate_property(_ghost, "global_position", null, _mouse_as_coordinate(128.0 if _size == Size.TINY else 256.0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		_ghost_tween.start()
		ShittySingleton.emit_signal("ruler_ended", _ghost.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event is InputEventMouseButton:
		if get_global_mouse_position().distance_to(global_position) > ($CollisionShape2D.shape as CircleShape2D).radius * scale.x:
			return
		
		if event.button_index == BUTTON_LEFT:
			_set_being_dragged(event.pressed)
			get_tree().set_input_as_handled()
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			pass


func _input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			_set_being_dragged(false)



func _mouse_as_coordinate(grid_snapping := 256.0) -> Vector2:
	var mouse_position := get_global_mouse_position() - _token_offset
	return Vector2(
		stepify(mouse_position.x, grid_snapping),
		stepify(mouse_position.y, grid_snapping)
	) + _token_offset



func _set_size(new_size: int) -> void:
	_size = new_size
	scale = Vector2.ONE * _size * SCALE_FACTOR
	
	match _size:
		Size.TINY:
			_token_offset = -Vector2(64.0, 64.0)
		Size.SMALL, Size.MEDIUM, Size.HUGE:
			_token_offset = Vector2(128.0, 128.0)
		Size.LARGE, Size.GARGANTUAN:
			_token_offset = Vector2.ZERO
	
	emit_signal("size_changed", _size)


func _set_being_dragged(new_status: bool) -> void:
	_being_dragged = new_status
	
	if _being_dragged:
		if not _ghost.visible:
			_ghost.global_position = global_position
			_ghost.visible = true
			ShittySingleton.emit_signal("ruler_started", _ghost.global_position)
	else:
		if _ghost.visible:
			_ghost.visible = false
			_ghost.global_position = _mouse_as_coordinate(128.0 if _size == Size.TINY else 256.0)
			ShittySingleton.emit_signal("ruler_dismissed")
			
			var travel_time := min(global_position.distance_to(_ghost.global_position) / (_move_speed * 512.0) , _max_travel_time)
			_movement_tween.interpolate_property(self, "global_position", null, _ghost.global_position, travel_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
			_movement_tween.start()
