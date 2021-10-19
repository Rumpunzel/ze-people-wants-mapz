extends Area2D

export(PackedScene) var _fire_vfx_scene: PackedScene

var amount: int
var magical: bool
var damage_type: int
var damage_type_string: String
var dc: int
var saving_throw_to_make: int
var to_take: int

var _circle_color: Color
var _arc_color: Color


onready var _parent: Node = get_parent()
onready var _collision_shape: CollisionShape2D = $CollisionShape2D
onready var _circle_shape: CircleShape2D = _collision_shape.shape
onready var _label: Label = $Label

onready var _fire_vfx: Particles2D = _fire_vfx_scene.instance()



func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("multi_target_dialog_done", self, "_on_multi_target_dialog_done")
	
	yield(get_tree(), "idle_frame")
	
	_parent.add_child(_fire_vfx)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			if mouse_event.pressed:
				var tokens := get_overlapping_areas()
				for area in tokens:
					if not area is Token:
						continue
					
					var token: Token = area
					token.damage(amount, magical, damage_type, damage_type_string, dc, saving_throw_to_make, to_take)
				
				match damage_type:
					Attack.MagicalDamageTypes.FIRE:
						_fire_vfx.scale = Vector2.ONE * _circle_shape.radius / Table.GRID_SIZE
						_fire_vfx.emitting = true
						_fire_vfx.global_position = global_position
				
				hide()
				get_tree().set_input_as_handled()
		
		elif mouse_event.button_index == BUTTON_RIGHT:
			if mouse_event.pressed:
				hide()
				get_tree().set_input_as_handled()
		
		elif mouse_event.button_index == BUTTON_WHEEL_UP:
			_circle_shape.radius = max(_circle_shape.radius - Table.GRID_SIZE * 0.25, Table.GRID_SIZE * 0.5)
			get_tree().set_input_as_handled()
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN:
			_circle_shape.radius += Table.GRID_SIZE * 0.25
			get_tree().set_input_as_handled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible:
		return
	
	global_position = get_global_mouse_position()
	update()
	_label.text = "%d %s damage\n%0.1fft" % [ amount, damage_type_string, _circle_shape.radius / Table.GRID_SIZE * 5.0 ]
	
	var tokens := get_overlapping_areas()
	for area in tokens:
		if not area.is_in_group(Monsters.MONSTER_GROUP):
			continue
		
		var token: Token = area
		token.modulate = _arc_color


func _draw() -> void:
	draw_circle(Vector2.ZERO, _circle_shape.radius, _circle_color)
	draw_arc(Vector2.ZERO, _circle_shape.radius, 0.0, TAU, 128, _arc_color, 4.0, true)



func _on_multi_target_dialog_done(new_amount: int, new_magical: bool, new_damage_type: int, new_damage_type_string: String, new_dc: int, new_saving_throw_to_make: int, new_to_take: int) -> void:
	amount = new_amount
	magical = new_magical
	damage_type = new_damage_type
	damage_type_string = new_damage_type_string
	dc = new_dc
	saving_throw_to_make = new_saving_throw_to_make
	to_take = new_to_take
	
	_arc_color = Attack.DAMAGE_COLORS[damage_type]
	_circle_color = _arc_color
	_circle_color.a = 0.5
	
	_collision_shape.disabled = false
	global_position = get_global_mouse_position()
	show()


func _on_area_exited(area: Area2D) -> void:
	if not area is Token:
		return
	
	var token: Token = area
	token.modulate = Color.white


func _on_hide() -> void:
	_collision_shape.disabled = true
	
	var tokens := get_overlapping_areas()
	for area in tokens:
		if not area is Token:
			continue
		
		var token: Token = area
		token.modulate = Color.white
