class_name Die
extends RigidBody


signal side_changed(die, new_side)

const NONE := -1

enum DiceTypes {
	d4 = 4,
	d6 = 6,
	d8 = 8,
	#d10 = 10,
	d12 = 12,
	d20 = 20,
	#d100 = 100,
}


export(DiceTypes) var dice_type := DiceTypes.d6

export(PackedScene) var _die_side_scene
export var _die_radius := 0.1
export var _side_scale := 1.0
export var _ray_cast_length := 0.55


var side_up := NONE

var _sides := [ ]


onready var _tween: Tween = $Tween



func _enter_tree() -> void:
	connect("side_changed", ShittySingleton, "display_result")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var number_of_sides := dice_type
	for index in range(number_of_sides):
		var die_side := _new_die_side()
		
		die_side.digit = index + 1
		die_side.transform.origin = Vector3(0.0, 0.0, _die_radius)
		
		match index:
			0:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.UP, 0)
			1:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.UP, PI / 2.0)
			2:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.RIGHT, PI / 2.0)
			3:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.RIGHT, -PI / 2.0)
			4:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.UP, -PI / 2.0)
			5:
				die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.UP, PI)
				#die_side.transform = rotate_around(die_side.transform, Vector3.ZERO, Vector3.UP, (float(index) / number_of_sides) * TAU)
		
		_sides.append(die_side)
		add_child(die_side)
	
	for die_side in _sides:
		die_side.set_exceptions(_sides)
	
	transform.basis = random_vector3()
	
	apply_torque_impulse(random_vector3() * 0.5)
	apply_central_impulse(random_vector3() * 4.0)


func _physics_process(_delta: float) -> void:
	if side_up == NONE and linear_velocity.abs().length_squared() < 0.01:
		side_up = _get_face_up()
		emit_signal("side_changed", self, side_up)
		
		if not side_up == NONE:
			sleeping = true



static func random_vector3() -> Vector3:
	return Vector3(random_float_in_range(), random_float_in_range(), random_float_in_range())

static func random_float_in_range(lower_bound := -1.0, upper_bound := 1.0) -> float:
	return lower_bound + randf() * (upper_bound - lower_bound)

static func roll(dice_number: int, die_type: int, use_expected_result := false) -> int:
	var result := 0
	
	if use_expected_result:
		result = int(dice_number * (die_type + 1) * 0.5)
	else:
		for _i in range(dice_number):
			result += randi() % die_type
	
	return result


func rotate_around(transform_to_rotate: Transform, point: Vector3, axis: Vector3, angle: float):
	# Rotate its basis
	var rotated_basis = transform_to_rotate.basis.rotated(axis, angle)
	
	# Rotate its origin
	var rotated_origin = point + (transform_to_rotate.origin - point).rotated(axis, angle)
	
	# Set the result back
	return Transform(rotated_basis, rotated_origin)



func _get_face_up() -> int:
	for child in _sides:
		var die_side: DieSide = child as DieSide
		
		if die_side.check_for_collision():
			return die_side.digit
	
	return NONE


func _new_die_side() -> DieSide:
	var die_side := _die_side_scene.instance() as DieSide
	die_side.scale = Vector3(_side_scale, _side_scale, _side_scale)
	die_side.cast_to = Vector3(0.0, 0.0, -_ray_cast_length)
	
	return die_side


func _on_sleeping_state_changed() -> void:
	if not sleeping:
		return
	
	var to_rotate := 0.0
	match(side_up):
		1, 4:
			pass
		
		2:
			to_rotate = -90.0
		
		3, 6:
			to_rotate = 180.0
		
		5:
			to_rotate = 90.0
	
	_tween.interpolate_property(self, "rotation_degrees:y", null, to_rotate, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	_tween.start()
