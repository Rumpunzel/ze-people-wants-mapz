extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_radio_check_item("Tiny", Attributes.Size.TINY)
	add_radio_check_item("Small", Attributes.Size.SMALL)
	add_radio_check_item("Medium", Attributes.Size.MEDIUM)
	add_radio_check_item("Large", Attributes.Size.LARGE)
	add_radio_check_item("Huge", Attributes.Size.HUGE)
	add_radio_check_item("Gargantuan", Attributes.Size.GARGANTUAN)
	
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
