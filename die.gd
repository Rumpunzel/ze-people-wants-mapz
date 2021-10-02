class_name Die
extends RigidBody


signal side_changed(die, new_side)

const NONE := -1

enum DiceTypes {
	d4 = 4,
	d6 = 6,
	d8 = 8,
	d10 = 10,
	d12 = 12,
	d20 = 20,
	d100 = 100,
}

export(DiceTypes) var dice_type := DiceTypes.d6

export var _ray_cast_length := 0.1

var side_up := NONE

onready var _sides := $Sides.get_children()
onready var _tween: Tween = $Tween



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	connect("side_changed", ShittySingleton, "display_result")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for side in _sides:
		var die_side: RayCast = side
		die_side.cast_to = die_side.cast_to.normalized() * _ray_cast_length
		die_side.enabled = true
	
	transform.basis = random_vector3()
	
	apply_torque_impulse(random_vector3() * 5.0)
	apply_central_impulse(random_vector3() * 20.0)


func _physics_process(_delta: float) -> void:
	if side_up == NONE and linear_velocity.abs().length_squared() < 0.1:
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



func _get_face_up() -> int:
	for side in _sides:
		var die_side: RayCast = side
		
		if die_side.is_colliding():
			return int(die_side.name)
	
	return NONE


func _on_sleeping_state_changed() -> void:
	if not sleeping:
		return
	
	var to_rotate := transform.basis
	match dice_type:
		DiceTypes.d6:
			match(side_up):
				1:
					to_rotate = Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK)
				2:
					to_rotate = Basis(Vector3.RIGHT, Vector3.FORWARD, Vector3.UP)
				3:
					to_rotate = Basis(Vector3.DOWN, Vector3.FORWARD, Vector3.RIGHT)
				4:
					to_rotate = Basis(Vector3.UP, Vector3.FORWARD, Vector3.LEFT)
				5:
					to_rotate = Basis(Vector3.LEFT, Vector3.FORWARD, Vector3.DOWN)
				6:
					to_rotate = Basis(Vector3.LEFT, Vector3.DOWN, Vector3.BACK)
		
		_:
			pass
	
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "transform:basis", null, to_rotate, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	_tween.start()
