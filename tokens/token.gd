tool
class_name Token
extends Area2D


const SCALE_FACTOR := 0.25


signal size_changed(new_size)
signal maximum_hit_points_changed(new_hit_points)
signal hit_points_changed(new_hit_points)
signal selected(new_status)
signal died()


export var color := Color.transparent setget set_color

export(Resource) var attributes


var image: TextureRect
var hit_points: int setget set_hit_points
var dead := false
var selected := false setget set_selected
var is_taking_turn := false setget set_is_taking_turn


var _size: int setget _set_size
var _min_travel_time = 0.5
var _max_travel_time = 2.0
var _being_dragged := false setget _set_being_dragged
var _token_offset := Vector2.ZERO

var _trail: Trail
var _background: Node2D
var _token: Sprite
var _ghost_tween: Tween
var _movement_tween: Tween


onready var _collision: CollisionShape2D = $CollisionShape2D
onready var _collision_shape: CircleShape2D = _collision.shape
onready var _selection: Sprite = $SelectionNode/Selection
onready var _animation_player: AnimationPlayer = $AnimationPlayer

onready var _ghost: Area2D = Area2D.new()



func _enter_tree() -> void:
	image = $Image
	_trail = $TrailNode/Trail
	_background = $Background
	_token = $Background/Token
	_ghost_tween = $GhostTween
	_movement_tween = $MovementTween


func _ready() -> void:
	_set_size(attributes.size)
	image.rect_pivot_offset = image.rect_size * 0.5
	
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
	
	var ghost_image: TextureRect = image.duplicate()
	_ghost.add_child(ghost_image)
	
	_ghost.name = "Ghost"
	_ghost.modulate.a = 0.5
	_ghost.visible = false
	_ghost.z_index = 5
	
	add_child(_ghost)
	ghost_image.texture = image.texture
	
	var new_max_hit_points: int = attributes.calculate_hit_points()
	emit_signal("maximum_hit_points_changed", new_max_hit_points)
	set_hit_points(new_max_hit_points)


func _process(_delta: float):
	if Engine.editor_hint:
		return
	
	if _being_dragged:
		# warning-ignore:return_value_discarded
		_ghost_tween.interpolate_property(_ghost, "global_position", null, _mouse_as_coordinate(Table.GRID_SIZE * (0.5 if _size == Attributes.Size.TINY else 1.0)), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
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
	if Engine.editor_hint or not visible:
		return
	
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			if get_global_mouse_position().distance_to(global_position) > _collision_shape.radius * scale.x:
				return
			
			if mouse_event.pressed:
				set_selected(true)
			
			_set_being_dragged(mouse_event.pressed)
			get_tree().set_input_as_handled()
	
	elif event is InputEventKey:
		var key_event: InputEventKey = event
		if selected and not key_event.pressed:
			match key_event.scancode:
				KEY_A:
					ShittySingleton.emit_signal("single_target_dialog_openend", self)
				
				KEY_DELETE:
					get_tree().set_input_as_handled()
					die()


func _input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			if get_global_mouse_position().distance_to(global_position) > _collision_shape.radius * scale.x:
				set_selected(false)
			if not mouse_event.pressed:
				_set_being_dragged(false)



func roll_initiative() -> Attributes.Initiative:
	return attributes.roll_initiative()

func damage(amount: int, magical: bool, damage_type: int, damage_type_string: String, dc: int, saving_throw_to_make: int, to_take: int) -> void:
	if saving_throw_to_make >= Attributes.Stats.STRENGTH:
		var saving_throw_result: int = attributes.saving_throw(saving_throw_to_make)
		if saving_throw_result >= dc:
			print("%s made the saving throw with a %d!" % [ name, saving_throw_result ])
			match to_take:
				ToTake.HALF_DAMAGE:
					amount /= 2
				ToTake.NO_DAMAGE:
					return
		else:
			print("%s failed the saving throw with a %d!" % [ name, saving_throw_result ])
	
	amount = attributes.get_modified_damage(amount, damage_type, magical)
	
	if amount == 0:
		print("%s resisted the attack of type %s!" % [ name, damage_type_string ])
		return
	
	print("Hit %s by %d with %s %s damage!" % [ name, amount, "magical" if magical else "non-magical", damage_type_string ])
	
	set_hit_points(hit_points - amount)
	
	var previous_animation := _animation_player.current_animation
	_animation_player.play("damaged")
	if not previous_animation.empty():
		yield(_animation_player, "animation_finished")
		_animation_player.play(previous_animation)



func _mouse_as_coordinate(grid_snapping := Table.GRID_SIZE) -> Vector2:
	var mouse_position := get_global_mouse_position() - _token_offset
	return Vector2(
		stepify(mouse_position.x, grid_snapping),
		stepify(mouse_position.y, grid_snapping)
	) + _token_offset


func set_hit_points(new_hit_points: int) -> void:
	hit_points = new_hit_points
	emit_signal("hit_points_changed", hit_points)
	
	if hit_points <= 0:
		modulate = Color.darkgray
		print("%s died!" % [ name ])
#	else:
#		modulate = Color.white


func set_is_taking_turn(new_status: bool) -> void:
	is_taking_turn = new_status
	
	if is_taking_turn and selected:
		_selection.modulate = Color.white
	elif is_taking_turn:
		_selection.modulate = Color.yellow
	else:
		_selection.modulate = Color.dodgerblue
	
	_selection.visible = is_taking_turn or selected


func set_selected(new_status: bool) -> void:
	selected = new_status
	
	if is_taking_turn and selected:
		_selection.modulate = Color.white
	elif is_taking_turn:
		_selection.modulate = Color.gold
	else:
		_selection.modulate = Color.dodgerblue
	
	_selection.visible = is_taking_turn or selected
	emit_signal("selected", selected)


func _set_size(new_size: int) -> void:
	_size = new_size
	scale = Vector2.ONE * _size * SCALE_FACTOR
	
	match _size:
		Attributes.Size.TINY:
			_token_offset = -Vector2(Table.GRID_SIZE, Table.GRID_SIZE) * 0.25
		Attributes.Size.SMALL, Attributes.Size.MEDIUM, Attributes.Size.HUGE:
			_token_offset = Vector2(Table.GRID_SIZE, Table.GRID_SIZE) * 0.5
		Attributes.Size.LARGE, Attributes.Size.GARGANTUAN:
			_token_offset = Vector2.ZERO
	
	emit_signal("size_changed", _size)


func die() -> void:
	if dead:
		queue_free()
	else:
		dead = true
		_collision.disabled = true
		modulate = Color.darkgray
		modulate.a = 0.25
		set_is_taking_turn(false)
		set_selected(false)
		_background.visible = false
		emit_signal("died")


func attack() -> void:
	var attacks: Array = attributes.attack
	for resource in attacks:
		var attack: Attack = resource
		for _i in attack.dice_amount:
			ShittySingleton.left_to_spawn.append(Die.DieToRoll.new(attack.die_type, attack.get_damage_type()))


func get_attack() -> Array:
	return attributes.attack


func set_color(new_color: Color) -> void:
	color = new_color
	if not color == Color.transparent:
		($TrailNode/Trail as Trail).set_color(color)
		($Background as Node2D).modulate = color


func _set_being_dragged(new_status: bool) -> void:
	_being_dragged = new_status
	
	if _being_dragged:
		if not _ghost.visible:
			_ghost.global_position = global_position
			_ghost.visible = true
			ShittySingleton.emit_signal("ruler_started", _ghost.global_position, color)
	else:
		if _ghost.visible:
			_ghost.visible = false
			_ghost.global_position = _mouse_as_coordinate(Table.GRID_SIZE * (0.5 if _size == Attributes.Size.TINY else 1.0))
			ShittySingleton.emit_signal("ruler_dismissed")
			
			var start_position := global_position
			var destination := _ghost.global_position
			var move_speed: int = attributes.move_speed
			
			var distance := start_position.distance_to(destination)
			var half_way_point := (start_position + destination) * 0.5 + Vector2(randf() - 0.5, randf() - 0.5) * distance * 0.25
			var travel_time := max(min(distance / (move_speed * 16.0) , (_max_travel_time * 16.0) / move_speed), _min_travel_time)
			var half_travel_time := travel_time * 0.6
			
			var start_transition := Tween.TRANS_BACK if move_speed > 20 else Tween.TRANS_CIRC
			var end_transition := Tween.TRANS_CIRC#Tween.TRANS_BACK if distance > 1536.0 else Tween.TRANS_CIRC
			
			# warning-ignore:return_value_discarded
			_movement_tween.interpolate_property(self, "global_position", start_position, half_way_point, half_travel_time, start_transition, Tween.EASE_IN)
			# warning-ignore:return_value_discarded
			_movement_tween.interpolate_property(self, "global_position", half_way_point, destination, travel_time - half_travel_time, end_transition, Tween.EASE_OUT, half_travel_time)
			# warning-ignore:return_value_discarded
			_movement_tween.start()
