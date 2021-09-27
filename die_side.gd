class_name DieSide
extends Spatial


export var digit := 1 setget _set_digit

var cast_to: Vector3 setget _set_cast_to, _get_cast_to



func _ready() -> void:
	_set_digit(digit)



func check_for_collision() -> bool:
	return $RayCast.is_colliding()

func set_exceptions(nodes: Array) -> void:
	for node in nodes:
		$RayCast.add_exception(node)



func _set_digit(new_digit: int) -> void:
	digit = new_digit
	var texture: ImageTexture = NumberViewport.get_die_side("%d" % digit)
	$Sprite3D.texture = texture

func _set_cast_to(new_cast_to: Vector3) -> void:
	cast_to = new_cast_to
	$RayCast.cast_to = cast_to


func _get_cast_to() -> Vector3:
	return $RayCast.cast_to
