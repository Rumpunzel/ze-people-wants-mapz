extends InitiativeEntry

onready var _name_label: Label = $MarginContainer/HBoxContainer/Name

var _moved_how_many_times := 1


func moved() -> void:
	_moved_how_many_times += 1
	_name_label.text = "Round %d" % [ _moved_how_many_times ]
