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

# warning-ignore-all:unused_class_variable
export(Material) var bludgeoning_material
export(Material) var piercing_material
export(Material) var slashing_material
export(Material) var acid_material
export(Material) var cold_material
export(Material) var fire_material
export(Material) var force_material
export(Material) var lightning_material
export(Material) var necrotic_material
export(Material) var poison_material
export(Material) var psychic_material
export(Material) var radiant_material
export(Material) var thunder_material


var side_up := NONE
var damage_type: int = -1


onready var _sides := $Sides.get_children()
onready var _tween: Tween = $Tween
onready var _animation_player: AnimationPlayer = $AnimationPlayer



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
	
	apply_torque_impulse(random_vector3() * 4.0)
	apply_central_impulse(random_vector3() * 16.0)


func _physics_process(_delta: float) -> void:
	if side_up == NONE and linear_velocity.abs().length_squared() < 0.1:
		side_up = _get_face_up()
		emit_signal("side_changed", dice_type, side_up)
		
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
			result += 1 + randi() % int(max(die_type, 1))
	
	return result



func setup(new_damage_type: int, damage_name: String) -> void:
	damage_type = new_damage_type
	
	var new_material: Material = get("%s_material" % damage_name)
	($MeshInstance as MeshInstance).material_override = new_material


func delete() -> void:
	_animation_player.play("delete")


func _delete() -> void:
	get_parent().remove_child(self)
	queue_free()



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



class DieToRoll:
	var die_type: int
	var use_3d_dice: bool
	var damage_type: int
	
	func _init(new_die_type: int, new_use_3d_dice = false, new_damage_type := -1) -> void:
		die_type = new_die_type
		use_3d_dice = new_use_3d_dice
		damage_type = new_damage_type
