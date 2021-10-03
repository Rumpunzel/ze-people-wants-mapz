tool
class_name Token
extends Area2D


const SCALE_FACTOR := 0.25


signal size_changed(new_size)
signal maximum_hit_points_changed(new_hit_points)

export(Resource) var _attributes
export var _color := Color.transparent setget _set_color


var _size: int setget _set_size
var _max_travel_time = 1.5
var _being_dragged := false setget _set_being_dragged
var _token_offset := Vector2.ZERO

var _trail: Trail
var _background: Node2D
var _token: Sprite
var _image: TextureRect
var _ghost_tween: Tween
var _movement_tween: Tween


onready var _collision: CollisionShape2D = $CollisionShape2D
onready var _collision_shape: CircleShape2D = _collision.shape
onready var _ghost: Area2D = Area2D.new()



func _enter_tree() -> void:
	_trail = $Node/Trail
	_background = $Background
	_token = $Background/Token
	_image = $Image
	_ghost_tween = $GhostTween
	_movement_tween = $MovementTween


func _ready() -> void:
	_set_size(_attributes.size)
	
	if Engine.editor_hint:
		return
	
	var ghost_background := _background.duplicate()
	
	var ghost_token: Sprite = ghost_background.get_node("Token")
	ghost_token.visible = _token.visible
	
	var ghost_light: Light2D = ghost_background.get_node_or_null("Light2D")
	if ghost_light:
		ghost_light.visible = false
	
	_ghost.add_child(ghost_background)
	
	var ghost_collision: CollisionShape2D = _collision.duplicate()
	_ghost.add_child(ghost_collision)
	ghost_collision.scale *= 0.9
	
	var ghost_image: TextureRect = _image.duplicate()
	_ghost.add_child(ghost_image)
	
	_ghost.name = "Ghost"
	_ghost.modulate.a = 0.5
	_ghost.visible = false
	_ghost.z_index = 5
	
	add_child(_ghost)
	ghost_image.texture = _image.texture
	
	emit_signal("maximum_hit_points_changed", _attributes.calculate_hit_points())


func _process(_delta: float):
	if Engine.editor_hint:
		return
	
	if _being_dragged:
		# warning-ignore:return_value_discarded
		_ghost_tween.interpolate_property(_ghost, "global_position", null, _mouse_as_coordinate(128.0 if _size == Attributes.Size.TINY else 256.0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		# warning-ignore:return_value_discarded
		_ghost_tween.start()
		
		var ghost_overlapping := _ghost.get_overlapping_areas()
		var colliding_with_other_tokens := not (ghost_overlapping.size() == 0 or (ghost_overlapping.size() == 1 and ghost_overlapping.has(self)))
		if colliding_with_other_tokens:
			_ghost.modulate = Color.red
		else:
			_ghost.modulate = Color.white
		
		_ghost.modulate.a = 0.5
		
		ShittySingleton.emit_signal("ruler_ended", _ghost.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if get_global_mouse_position().distance_to(global_position) > _collision_shape.radius * scale.x:
			return
		
		if mouse_event.button_index == BUTTON_LEFT:
			_set_being_dragged(mouse_event.pressed)
			get_tree().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT and not mouse_event.pressed:
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
		Attributes.Size.TINY:
			_token_offset = -Vector2(64.0, 64.0)
		Attributes.Size.SMALL, Attributes.Size.MEDIUM, Attributes.Size.HUGE:
			_token_offset = Vector2(128.0, 128.0)
		Attributes.Size.LARGE, Attributes.Size.GARGANTUAN:
			_token_offset = Vector2.ZERO
	
	emit_signal("size_changed", _size)


func _set_color(new_color: Color) -> void:
	_color = new_color
	if not _color == Color.transparent:
		($Node/Trail as Trail).set_color(_color)
		($Background as Node2D).modulate = _color


func _set_being_dragged(new_status: bool) -> void:
	_being_dragged = new_status
	
	if _being_dragged:
		if not _ghost.visible:
			_ghost.global_position = global_position
			_ghost.visible = true
			ShittySingleton.emit_signal("ruler_started", _ghost.global_position, _color)
	else:
		if _ghost.visible:
			_ghost.visible = false
			_ghost.global_position = _mouse_as_coordinate(128.0 if _size == Attributes.Size.TINY else 256.0)
			ShittySingleton.emit_signal("ruler_dismissed")
			
			var start_position := global_position
			var destination := _ghost.global_position
			var half_factor := 0.6
			var move_speed: int = _attributes.move_speed
			
			var half_way_point := (start_position + destination) * half_factor
			var distance := start_position.distance_to(destination)
			var travel_time := min(distance / (move_speed * 16.0) , (_max_travel_time * 16.0) / move_speed)
			var half_travel_time := travel_time * half_factor
			
			var start_transition := Tween.TRANS_BACK if move_speed > 20 else Tween.TRANS_CIRC
			var end_transition := Tween.TRANS_CIRC#Tween.TRANS_BACK if distance > 1536.0 else Tween.TRANS_CIRC
			
			# warning-ignore:return_value_discarded
			_movement_tween.interpolate_property(self, "global_position", start_position, half_way_point, half_travel_time, start_transition, Tween.EASE_IN)
			# warning-ignore:return_value_discarded
			_movement_tween.interpolate_property(self, "global_position", half_way_point, destination, travel_time - half_travel_time, end_transition, Tween.EASE_OUT, half_travel_time)
			# warning-ignore:return_value_discarded
			_movement_tween.start()
