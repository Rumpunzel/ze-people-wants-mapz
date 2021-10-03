extends Control

onready var _tracker: Control = $InitiativeHUD
onready var _player_initiatives: PlayerInitiatives = $PlayerInitiatives


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			match(key_event.scancode):
				KEY_I:
					if _tracker.visible:
						_tracker.visible = false
					else:
						_player_initiatives.display()
					
					get_tree().set_input_as_handled()
