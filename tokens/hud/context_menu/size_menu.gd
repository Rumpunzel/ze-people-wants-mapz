extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for value in Attributes.Size.keys():
		var size: String = value
		var flag_value: int = Attributes.Size[size]
		
		add_radio_check_item(size.capitalize(), flag_value)
	
	yield(get_tree(), "idle_frame")
	
	var token: Token = owner
	set_item_checked(get_item_index(token.size), true)


func _on_visibility_changed() -> void:
	if visible:
		modulate.a = 0.0
		yield(get_tree(), "idle_frame")
		
		var parent: PopupMenu = get_parent()
		rect_global_position = Vector2(
			parent.rect_global_position.x + parent.rect_size.x,
			parent.rect_global_position.y
		)
		modulate.a = 1.0
