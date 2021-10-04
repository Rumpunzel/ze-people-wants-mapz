extends ProgressBar


onready var _current: Label = get_node("../LifeDisplay/Current")
onready var _max: Label = get_node("../LifeDisplay/Max")


func _ready() -> void:
	_on_value_changed(value)
	_on_changed()


func _on_value_changed(_new_value: float) -> void:
	_current.text = "%d" % value

func _on_changed() -> void:
	_max.text = "%d" % max_value


func _on_maximum_hit_points_changed(new_hit_points: int) -> void:
	max_value = new_hit_points
	value = max_value
