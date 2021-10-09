extends Area2D

var amount: int
var magical: bool
var damage_type: int
var damage_type_string: String
var dc: int
var saving_throw_to_make: int
var to_take: int

onready var _collision_shape: CollisionShape2D = $CollisionShape2D
onready var _circle_shape: CircleShape2D = _collision_shape.shape
onready var _label: Label = $Label


func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("multi_target_dialog_done", self, "_on_multi_target_dialog_done")


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
				
				hide()
				get_tree().set_input_as_handled()
		
		elif mouse_event.button_index == BUTTON_RIGHT:
			if mouse_event.pressed:
				hide()
				get_tree().set_input_as_handled()
		
		elif mouse_event.button_index == BUTTON_WHEEL_UP:
			_circle_shape.radius = max(_circle_shape.radius - 64.0, 128.0)
			get_tree().set_input_as_handled()
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN:
			_circle_shape.radius += 64.0
			get_tree().set_input_as_handled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible:
		return
	
	global_position = get_global_mouse_position()
	update()
	_label.text = "%d %s damage\n%0.1fft" % [ amount, damage_type_string, _circle_shape.radius / 256.0 * 5.0 ]
	
	var tokens := get_overlapping_areas()
	for area in tokens:
		if not area is Token:
			continue
		
		var token: Token = area
		token.modulate = Color.cornflower


func _draw() -> void:
	draw_circle(Vector2.ZERO, _circle_shape.radius, Color("966394ed"))
	draw_arc(Vector2.ZERO, _circle_shape.radius, 0.0, TAU, 128, Color.cornflower, 4.0, true)


func _on_multi_target_dialog_done(new_amount: int, new_magical: bool, new_damage_type: int, new_damage_type_string: String, new_dc: int, new_saving_throw_to_make: int, new_to_take: int) -> void:
	amount = new_amount
	magical = new_magical
	damage_type = new_damage_type
	damage_type_string = new_damage_type_string
	dc = new_dc
	saving_throw_to_make = new_saving_throw_to_make
	to_take = new_to_take
	
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
