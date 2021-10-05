extends ProgressBar


export var _health_color := Color.darkgreen
export var _damaged_color := Color.darkred

onready var _current: Label = get_node("../LifeDisplay/Current")
onready var _max: Label = get_node("../LifeDisplay/Max")

onready var _damage_bar: ProgressBar = $DamageBar
onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween



func _ready() -> void:
	_on_value_changed(value)
	_on_changed()



func _on_value_changed(_new_value: float) -> void:
	_current.text = "%d" % value
	_set_color()
	_timer.start()

func _on_changed() -> void:
	_max.text = "%d" % max_value


func _on_maximum_hit_points_changed(new_hit_points: int) -> void:
	max_value = new_hit_points
	value = max_value
	_damage_bar.max_value = max_value


func _set_color() -> void:
	var health_ratio := value / max_value
	self_modulate = _health_color * health_ratio + _damaged_color * (1.0 - health_ratio)


func _on_timeout() -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_damage_bar, "value", null, value, 0.2, Tween.TRANS_CIRC, Tween.EASE_IN)
	# warning-ignore:return_value_discarded
	_tween.start()
