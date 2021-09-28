extends ProgressBar


onready var _current: Label = $LifeDisplay/Current
onready var _max: Label = $LifeDisplay/Max


func _ready() -> void:
	_on_value_changed(value)
	_on_changed()


func _on_value_changed(new_value: float) -> void:
	_current.text = "%d" % new_value

func _on_changed() -> void:
	_max.text = "%d" % max_value
