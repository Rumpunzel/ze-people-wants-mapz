extends CheckButton


export(Texture) var _magical_icon
export(Texture) var _non_magical_icon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_toggled(button_pressed: bool) -> void:
	text = "Magical" if button_pressed else "Non-Magical"
	icon = _magical_icon if button_pressed else _non_magical_icon
